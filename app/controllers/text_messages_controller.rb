class TextMessagesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource

  layout "dashboard"

  def show
    @text_message = TextMessage.find(params[:id])
    render :layout => false
  end
  
  def new
    if params["step"].present?
      @step = params["step"]
    else
      @step = "1"
    end
    
    if params[:text_message] && params[:text_message][:content]
		params[:text_message][:content].gsub!(/[\~`\^\|\\]/i, "+")
    end
    
    if session[:text_message].present?
      session[:text_message] = session[:text_message].merge(params[:text_message]) if params[:text_message].present?
      if params[:list_ids].present? and params[:list_ids].size > 0
        session[:text_message] = session[:text_message].merge({:list_ids => params[:list_ids].join(",")})
      elsif @step == "3" and session[:text_message][:number_of_recipients].blank?
        flash[:alert] = "Please Select at least one contact list!"
        @step = "2"
      elsif @step == "3" and request.post? and session[:text_message][:list_ids].present? and params[:list_ids].blank?
        session[:text_message][:list_ids] = nil
        flash[:alert] = "Please Select at least one contact list!"
        @step = "2"
      end
      #session[:text_message][:content] = session[:text_message][:content].squish if session[:text_message][:content].present?
      @text_message = current_user.text_messages.new(session[:text_message])
    elsif params[:text_message].present?
      @text_message = current_user.text_messages.new(params[:text_message])
      session[:text_message] = params[:text_message]
    else
      @text_message = TextMessage.new
    end
    #debugger
    if params["step"] == "3" and params[:text_message].present?
      begin
        numbers = []
        @text_message.lists.each do |list|
          numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
        end
        number_of_contacts = (numbers - current_user.dnc.pluck(:phone).uniq).size
        cost_per_text = current_user.subscription.plan.price_per_call_or_text / 100.0
        message_size = (@text_message.content.length.to_f / 160.0).ceil

        new_hash = {
          :number_of_recipients => number_of_contacts,
          :cost_per_text => cost_per_text,
          :number_of_texts_required => message_size * number_of_contacts,
          :total_cost => message_size * number_of_contacts * cost_per_text
        }
      
        session[:text_message] = session[:text_message].merge(new_hash)
        @text_message = current_user.text_messages.new(session[:text_message])
      rescue => e
        puts e.message
        @step = "2"
      end
    end

    @current_balance = current_user.account_balance.current_balance
    @short_code = ShortCode.first

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @text_message = current_user.text_messages.new(session[:text_message])
    @current_balance = current_user.account_balance.current_balance

    #debugger
    # convert schedule_at time user time zone to utc time zone
    unless params[:auto_approved].blank?
      current_user.update_attributes(:text_messages_approval => "applied")
    end
    require 'chronic'
    Time.zone = current_user.time_zone
    Chronic.time_class = Time.zone
    start_time_string = "#{session[:text_message]["schedule_at(1i)"]}-#{session[:text_message]["schedule_at(2i)"]}-#{session[:text_message]["schedule_at(3i)"]} at #{session[:text_message]["schedule_at(4i)"]}:#{session[:text_message]["schedule_at(5i)"]} #{session[:text_message]["schedule_at(7i)"]}"
    start_time = Chronic.parse(start_time_string)
    
    if start_time <= Time.now or session[:text_message][:schedule_now] == "1"
      start_time = Time.zone.now + 5.seconds
    end
    Time.zone = "UTC"
    
    @text_message.schedule_at = start_time.utc

    if current_user.billing_setting.card or (@current_balance >= @text_message.total_cost and !current_user.subscription.plan.card_required)
      if @text_message.save
        session.delete(:text_message)
        redirect_to dashboard_path, :notice => "Successfully placed the text messages into queue!"
      else
        redirect_to send_text_path, :alert => "Something went wrong! Please try again!"
      end
    else
      redirect_to billing_path, :alert => "You must have a Card on file to perform this task!"
    end
  end

  def send_a_test
    @text_message = current_user.text_messages.new(session[:text_message])

    numbers = params[:numbers].split(/[,]/).reject{|n| n.length < 3 }

    if(Rails.env == 'development')
      from = "+15005550006" #valid for Test
    else
      shortcode = ShortCode.first
      if @text_message.sending_option != 1 and shortcode.present?
        from = shortcode.number
      else
        from = current_user.twilio_phone_number.phone_number
      end
    end

    count = 0
    numbers.each do |number|
      to = number
      response = TwilioRequest::send_message(from, to, @text_message.content)
      count += 1 if response == "true"
    end

    if numbers.size == count
      flash.now.notice = "Your test messages have been successfully sent."
    elsif count > 0
      flash.now.notice = "Your #{count} test messages have been successfully sent."
    else
      flash.now.alert = "Something went wrong! Please contact customer care."
    end

    respond_to do |format|
      format.js
    end
  end

  def send_text_succeeded_numbers
    @text_message = TextMessage.find(params[:id])
    
    respond_to do |format|
      if @text_message.present? and @text_message.user_id == current_user.id
        format.html { render text: @text_message.to_csv_succeeded_numbers }
        format.csv { render text: @text_message.to_csv_succeeded_numbers }
      else
        format.html { redirect_to dashboard_path }
        format.csv { redirect_to dashboard_path, :alert => "You are not authorized to download this file!" }
      end
    end
  end

  def send_text_errors
    @text_message = TextMessage.find(params[:id])

    respond_to do |format|
      if @text_message.present? and @text_message.user_id == current_user.id
        format.html { render text: @text_message.to_csv_errors }
        format.csv { render text: @text_message.to_csv_errors }
      else
        format.html { redirect_to dashboard_path }
        format.csv { redirect_to dashboard_path, :alert => "You are not authorized to download this file!" }
      end
    end
  end
end
