class TextMessagesController < ApplicationController
  before_filter :require_login

  layout "dashboard"
  
  def new
    if params["step"].present?
      @step = params["step"]
    else
      @step = "1"
    end

    if session[:text_message].present?
      session[:text_message] = session[:text_message].merge(params[:text_message]) if params[:text_message].present?
      if params[:list_ids].present? and params[:list_ids].size > 0
        session[:text_message] = session[:text_message].merge({:list_ids => params[:list_ids].join(",")})
      elsif session[:text_message][:list_ids].blank?
        flash.now.alert = "Please Select at least one contact list!"
        @step = "2"
      elsif @step == "3" and session[:text_message][:list_ids].present? and params[:list_ids].blank?
        session[:text_message][:list_ids] = nil
        flash.now.alert = "Please Select at least one contact list!"
        @step = "2"
      end
      @text_message = current_user.text_messages.new(session[:text_message])
    elsif params[:text_message].present?
      @text_message = current_user.text_messages.new(params[:text_message])
      session[:text_message] = params[:text_message]
    else
      @text_message = TextMessage.new
    end

    if params["step"] == "3" and params[:text_message].present?
      begin
        number_of_contacts = 0
        @text_message.lists.each do |list|
          number_of_contacts += list.number_of_contacts
        end
      
        cost_per_text = current_user.subscription.plan.price_per_call_or_text / 100.0
        message_size = (@text_message.content.length.to_f / 140.0).ceil

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

    puts session[:text_message].inspect
    puts @text_message.inspect

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @text_message = current_user.text_messages.new(session[:text_message])

    #
    # convert schedule_at time user time zone to utc time zone
    #
    #    Time.zone = current_user.time_zone
    #    start_time_string = "#{session[:text_message]["schedule_at(1i)"]}-#{session[:text_message]["schedule_at(2i)"]}-#{session[:text_message]["schedule_at(3i)"]} #{session[:text_message]["schedule_at(4i)"]}:#{session[:text_message]["schedule_at(5i)"]}:00 #{session[:text_message]["schedule_at(7i)"]}"
    #    start_time = Time.zone.parse(start_time_string)
    require 'chronic'
    Time.zone = current_user.time_zone
    Chronic.time_class = Time.zone
    start_time_string = "#{session[:text_message]["schedule_at(1i)"]}-#{session[:text_message]["schedule_at(2i)"]}-#{session[:text_message]["schedule_at(3i)"]} at #{session[:text_message]["schedule_at(4i)"]}:#{session[:text_message]["schedule_at(5i)"]} #{session[:text_message]["schedule_at(7i)"]}"
    start_time = Chronic.parse(start_time_string)
    
    if start_time <= Time.now
      start_time = Time.now + 5.minutes
    end
    Time.zone = "UTC"
    
    @text_message.schedule_at = start_time.utc

    if @text_message.save
      session.delete(:text_message)
      redirect_to dashboard_path, :notice => "Successfully placed the text messages into queue!"
    else
      redirect_to send_text_path
    end
  end

  def send_a_test
    @text_message = current_user.text_messages.new(session[:text_message])

    numbers = params[:numbers].split(/,\s+|[,]|\s+/).reject{|n| n.length < 3 }

    #from = current_user.twilio_phone_number.phone_number #if @text_message.sending_option == 1
    #from = "47543" if @text_message.sending_option != 1

    from = "+15005550006" #valid for Test

    count = 0
    numbers.each do |number|
      to = number
      body = @text_message.content
      response = TwilioRequest::send_message(from, to, body)
      count += 1 if response
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
end
