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
    user = twilio_phone_number.user if twilio_phone_number.present?

    if user.present?
      list = List.find_by_keyword_and_user_id(params["Body"], user.id)

      if list.present?
        contact = Contact.find_by_phone_number_and_user_id_and_list_id(from_phone_number,user.id,list.id)
        contact = Contact.find_by_phone_number_and_user_id_and_list_id(params["From"],user.id,list.id) if contact.blank?
      end

      contact = Contact.find_by_phone_number_and_user_id(from_phone_number,user.id) if contact.blank?
      contact = Contact.find_by_phone_number_and_user_id(params["From"],user.id) if contact.blank?

      if (contact.blank? and list.present?) or (contact.present? and list.present? and contact.list_id != list.id)
        contact = list.contacts.new
        contact.user_id = list.user.id
        contact.phone_number = from_phone_number
        contact.city = params["FromCity"]
        contact.state = params["FromState"]
        contact.zip = params["FromZip"]
        contact.custom_1 = params["FromCountry"]
        contact.source = "sms by keyword"
        contact.save
        reply_text = "Welcome to #{user.organization_name}'s text alerts! Msg&data rates may apply. Reply HELP for help, STOP to cancel. Frequency of msgs depends on user."
    
      elsif contact.present? and list.present? and contact.list_id == list.id
        reply_text = "Welcome to #{user.organization_name}'s text alerts! Msg&data rates may apply. Reply HELP for help, STOP to cancel. Frequency of msgs depends on user."

      elsif contact.present? and params["Body"].downcase == "stop"
        contacts = Contact.find(:all,
          :conditions => ["(phone_number = ? or phone_number = ?) and user_id = ?",params["From"],from_phone_number, user.id])
        contacts.each{ |c| c.destroy }
        reply_text = "You are opted out from #{user.organization_name}'s alerts. No more messages will be sent. Reply HELP for help or email Info@RoboCent.com. Msg&Data rates may apply."
    
      elsif contact.blank? and params["Body"].downcase == "stop"
        reply_text = "You are opted out from RoboCent's alerts. No more messages will be sent. Reply HELP for help or email Info@RoboCent.com. Msg&Data rates may apply."
        # Add to global dnc list

      elsif params["Body"].downcase == "help"
        reply_text = "Thank you for contacting us! Please contact Info@RoboCent.com or 888-849-6231 for assistance. Reply STOP to cancel. Msg&Data rates may apply. Frequency of msgs depends on user."
        
      else
        sms = SmsMessage.new
        sms.user_id = user.id if user.present?
        sms.contact_id = contact.id if contact.present?
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
      end
    else
      reply_text = "An error has occured, please email Info@RoboCent.com with any questions. Msg&Data rates may apply"
      logger.info "User not found! Please check this Twilio number #{params["To"]}!"
      # send email to Admin
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

end