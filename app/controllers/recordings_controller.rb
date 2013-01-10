class RecordingsController < ApplicationController
  before_filter :require_login, :except => [:new]

  require 'twilio-ruby'

  layout "dashboard"
  
  def new
    if params["Digits"].present? and params["Digits"].length == 6
      tpn = TwilioPhoneNumber.find_by_pin_number(params["Digits"])
      if tpn.present?
        user = tpn.user
        session[:new_record_user_id] = user.id
      else
        pin_error = true
      end
    end

    user = User.find(session[:new_record_user_id]) if user.blank? and session[:new_record_user_id].present?

    if user.present?
      if (params["Digits"].present? and params["Digits"].length == 1) or params["RecordingUrl"].present?
        if params["RecordingUrl"].present?
          url = params["RecordingUrl"]
          duration = params["RecordingDuration"]
          sid = params["RecordingSid"]
          session[:new_recording] = {:url => url, :duration => duration, :sid => sid}
        end

        if params["Digits"].present? and params["Digits"] == "#" and  session[:new_recording].present?
          response = Twilio::TwiML::Response.new do |r|
            r.Play "#{url}"
            r.Gather(:timeout => "10", :numDigits => "1", :method => "GET") do |g|
              r.Say "You may press 1 to save or press 2 to re-record."
            end
            r.Say "We didn't receive any input. Goodbye!"
          end
        elsif params["Digits"].present? and params["Digits"] == "2"
          puts "face 2"
          response = Twilio::TwiML::Response.new do |r|
            r.Say "Please leave a message after the beep. Press hash when finished."
            r.Record(:method => "GET", :playBeep => true, :finishOnKey => "#")
            r.Say "We didn't receive any voice. Goodbye!"
          end
        elsif session[:new_recording].present? and params["Digits"] == "1"
          #saving.......
          recording = user.recordings.new(session[:new_recording])
          recording.save
          response = Twilio::TwiML::Response.new do |r|
            r.Say "Your recording is successfully completed. Thank You"
          end
        else
          response = Twilio::TwiML::Response.new do |r|
            r.Gather(:timeout => "10", :numDigits => "1", :method => "GET") do |g|
              r.Say "You may press 1 to save or press 2 to re-record."
            end
            r.Say "We didn't receive any input. Goodbye!"
          end
        end

      else
        response = Twilio::TwiML::Response.new do |r|
          r.Say "Please leave a message after the beep. Press hash when finished."
          r.Record(:method => "GET", :playBeep => true, :finishOnKey => "#")
          r.Say "We didn't receive any voice. Goodbye!"
        end
      end
    else
      # First time or if pin in wrong
      response = Twilio::TwiML::Response.new do |r|
        r.Gather(:timeout => "10", :numDigits => "6", :method => "GET") do |g|
          g.Say "This pin number is wrong." if pin_error.present?
          g.Say "Please enter your pin number."
        end
        r.Say "We didn't receive any input. Goodbye!"
      end
    end

    logger.info response.text
    
    # print the result
    render :text => response.text
  end

  def edit
    @recording = Recording.find(params[:id])
    if @recording.user_id == current_user.id
      render :layout => false
    else
      render :text => "You are not authorized to edit this record!"
    end
  end

  def update
    @recording = Recording.find(params[:id])
    
    respond_to do |format|
      if @recording.update_attributes(params[:recording])
        format.html { redirect_to send_call_path, notice: 'Recording was successfully updated.' }
        format.js
      else
        format.html { redirect_to send_call_path }
        format.js
      end
    end
  end

  def find_new_recording
    last_loaded_rec = params["last_rec"]

    puts last_loaded_rec

    @recordings = current_user.recordings.where("id > #{last_loaded_rec}").order("created_at ASC")

    respond_to do |format|
      format.js
    end
  end
end