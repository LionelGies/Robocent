class SmsMessagesController < ApplicationController
  before_filter :require_login, :except => [:new]
  
  require 'twilio-ruby'

  layout "dashboard"

  def new
    #
    # Receive SMS From Twilio
    #
    from_phone_number = formatted_number(params["From"])
    
    twilio_phone_number = TwilioPhoneNumber.find_by_phone_number(params["To"])
    short_code = ShortCode.find_by_number(params["To"])
    
    if twilio_phone_number.present?
      user = twilio_phone_number.user
      list = List.find_by_keyword_and_user_id(params["Body"], user.id)
    elsif short_code.present?
      contacts = Contact.where(:phone_number => from_phone_number)
      list = List.find_by_shortcode_keyword(params["Body"])
      if contacts.present? and contacts.count > 1 and list.blank?
        text_message_ids = []
        contacts.each do |contact|
          text_messages = TextMessage.where("sending_option <> 1 and status = 'finished' and ? in (list_ids)", contact.list_id)
          text_message_ids += text_messages.map(&:id) if text_messages.present?
        end
        text_messages = TextMessage.where("id in (?)", text_message_ids).order("schedule_at desc")
        if text_messages.present?
          user = text_messages.first.user
        end
      elsif contacts.present? and contacts.count == 1 and list.blank?
        user = contacts.first.user
      end
    end

    if list.present?
      user = list.user
      greeting_text = list.greeting.present? ? "#{list.greeting}." : "Welcome to #{user.organization_name.present? ? user.organization_name : user.name}'s text alerts!"
      contact = Contact.where(:list_id => list.id, :phone_number => from_phone_number)
      if contact.present?
        reply_text = "#{greeting_text} Text HELP for help and STOP to quit. Msg&data rates may apply. Frequency depends on user. Sent via RoboCent.com"
      else
        contact = list.contacts.new
        contact.user_id = list.user.id
        contact.phone_number = from_phone_number
        contact.city = params["FromCity"]
        contact.state = params["FromState"]
        contact.zip = params["FromZip"]
        contact.custom_1 = params["FromCountry"]
        contact.source = "sms by keyword"
        contact.save
        reply_text = "#{greeting_text} Text HELP for help and STOP to quit. Msg&data rates may apply. Frequency depends on user. Sent via RoboCent.com"
      end

    elsif params["Body"].downcase == "help"
      reply_text = "Thank you for contacting us! Please contact Info@RoboCent.com or 888-849-6231 for assistance. Reply STOP to cancel. Msg&Data rates may apply. Frequency of msgs depends on user."
    
    elsif params["Body"].downcase == "stop"
      if user.present?
        user.contacts.where(:phone_number => from_phone_number).each do |c|
          c.destroy
        end
        reply_text = "You are opted out from #{user.organization_name.present? ? user.organization_name : user.name}'s alerts. No more messages will be sent. Reply HELP for help or email Info@RoboCent.com. Msg&Data rates may apply."
      else
        # Add to global dnc list
        dnc = Dnc.new(:phone => params["From"], :global => true)
        dnc.save
        reply_text = "You are opted out from RoboCent's alerts. No more messages will be sent. Reply HELP for help or email Info@RoboCent.com. Msg&Data rates may apply."
      end

    elsif user.present?
      contacts = Contact.where(:user_id => user.id, :phone_number => from_phone_number)
      sms = SmsMessage.new
      sms.user_id = user.id 
      sms.contact_id = contacts.first.id if contacts.present?
      sms.sms_sid = params["SmsSid"]
      sms.body = params["Body"]
      sms.to = params["To"]
      sms.from = params["From"]
      sms.from_state = params["FromState"]
      sms.from_city = params["FromCity"]
      sms.from_country = params["FromCountry"]
      sms.from_zip = params["FromZip"]
      sms.status = params["SmsStatus"]
      sms.save
    else
      reply_text = "Please email Info@RoboCent.com with any questions. Msg&Data rates may apply"
    end

    
    # build up a response
    response = Twilio::TwiML::Response.new do |r|
      if reply_text.present?
        reply_text = reply_text.scan(/.{1,160}/)
        reply_text.each do |text|
          r.Sms "#{text}"
        end
      end
    end

    # print the result
    render :text => response.text
  end

  def inbox
    @sms_messages = current_user.sms_messages.where(:status => "received")
  end

  def inbox_read
    @sms_messages = current_user.sms_messages.find(:all, :conditions => ["sms_messages.read = ? and status = ?", false, "received"])
    @sms_messages.each do |sms|
      sms.read = true
      sms.save
    end
    render :js => ""
  end
  
  def show
    @sms_message = SmsMessage.find(params[:id])
    @contact = current_user.contacts.find_by_phone_number(@sms_message.from)
    @contact = current_user.contacts.find_by_phone_number(formatted_number(@sms_message.from)) if @contact.blank?
    @new_sms = SmsMessage.new
    if @sms_message.user == current_user
      render :layout => false
    else
      render :text => "You are not authorized to view this page!"
    end
  end

  def start_conversation
    @new_sms = SmsMessage.new
    render :layout => false
  end

  def create
    @sms_message = current_user.sms_messages.new(params[:sms_message])

    if @sms_message.save
      number_of_text_required = (@sms_message.body.length.to_f / 160.0).ceil
      
      # make charge user account
      cost_per_text = current_user.subscription.plan.price_per_call_or_text.to_f / 100.0
      cost = cost_per_text * number_of_text_required.to_f
      r = Receipt.new(:memo => "To send #{number_of_text_required} text message(s)",
        :debit => cost)
      current_user.receipts << r

      #
      # Send message to twilio
      if(Rails.env == 'development')
        from = "+15005550006" #valid for Test
      else
        from = @sms_message.from
      end

      to = @sms_message.to


      response = TwilioRequest::send_message(from, to, @sms_message.body)

      if response == "true"
        flash.now.notice = "Successfully sent your message!"
        @sms_message.status = "sent"
      else
        flash.now.alert = response
        @sms_message.status = "failed"
      end
      
      @sms_message.save
    else
      flash.now.alert = "Something went wrong! Please contact Info@RoboCent.com"
    end
  end

end