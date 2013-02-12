class RecordingsController < ApplicationController
  before_filter :require_login, :except => [:new, :replay, :save_or_record, :show]
  load_and_authorize_resource :recording, :except => [:new, :replay, :save_or_record, :show]

  require 'twilio-ruby'

  layout "dashboard"
  
  def new
    if params["Digits"].present? and params["Digits"].length == 6
      tpn = TwilioPhoneNumber.find_by_pin_number(params["Digits"])
      if tpn.present?
        user = tpn.user
      else
        pin_error = true
      end
    end

    #  user = User.find(session[:new_record_user_id]) if user.blank? and session[:new_record_user_id].present?

    if user.present?
      #After Pin Validation
      response = Twilio::TwiML::Response.new do |r|
        r.Play "#{root_url}ivr/RobocentRecording-556.mp3"
        r.Record(:action => replay_path(:user_id => user.id), :method => "GET", :playBeep => true, :finishOnKey => "#", :maxLength => "90")
        r.Say "We didn't receive any voice. Goodbye!", :voice => "woman"
      end
    else
      #First Time or if Pin is wrong
      response = Twilio::TwiML::Response.new do |r|
        r.Gather(:timeout => "10", :finishOnKey => "*", :method => "GET") do |g|
          if pin_error.present?
            g.Play "#{root_url}ivr/RobocentRecording-557.mp3"
          else
            g.Play "#{root_url}ivr/NewPrompt.mp3"
          end
        end
        r.Say "We didn't receive any input. Goodbye!", :voice => "woman"
      end
    end

    logger.info response.text
    
    # print the result
    render :text => response.text
  end

  def replay
    user = User.find(params["user_id"])
    url = params["RecordingUrl"]
    duration = params["RecordingDuration"]
    
    response = Twilio::TwiML::Response.new do |r|
      r.Gather(:action => save_or_record_path(:user_id => user.id, :url => url, :duration => duration), :timeout => "5", :finishOnKey => "*", :method => "GET") do |g|
        g.Play "#{root_url}ivr/RobocentRecording-558.mp3"
        g.Play "#{url}.wav"
      end
      r.Say "We didn't receive any voice. Goodbye!", :voice => "woman"
    end
    logger.info response.text

    # print the result
    render :text => response.text
  end

  def save_or_record
    user = User.find(params["user_id"])

    if(params["Digits"] == "1")
      url = params["url"]
      duration = params["duration"]

      recording = user.recordings.new({:url => url, :duration => duration })
      recording.save

      response = Twilio::TwiML::Response.new do |r|
        r.Play "#{root_url}ivr/RobocentRecording-560.mp3"
      end

    elsif(params["Digits"] == "2")
      response = Twilio::TwiML::Response.new do |r|
        r.Play "#{root_url}ivr/RobocentRecording-556.mp3"
        r.Record(:action => replay_path(:user_id => user.id), :method => "GET", :playBeep => true, :finishOnKey => "#", :maxLength => "90")
        r.Say "We didn't receive any voice. Goodbye!", :voice => "woman"
      end
    end

    #logger.info response.text

    # print the result
    render :text => response.text
  end

  def create
    @recording = current_user.recordings.new(params[:recording])
    if @recording.save
      redirect_to send_call_path, :notice => "Successfully Uploaded"
    else
      if @recording.file.blank?
        flash[:alert] = @recording.errors.messages[:file].first
      else
        flash[:alert] = "Something went wrong, please try again!"
      end
      redirect_to send_call_path
    end
  end

  def edit
    @recording = Recording.find(params[:id])
    if @recording.userID == current_user.id
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

    @recordings = current_user.recordings.where("id > #{last_loaded_rec} and file IS NOT NULL").order("created_at ASC")

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @recording = Recording.find(params[:id])
    @recording.destroy
    redirect_to send_call_path
  end

  def play
    @recording = Recording.find(params[:id])
    render :layout => false
  end

  def show
    file_name = params[:id]
    path = "#{Rails.root}/public/recordings/#{file_name}.wav"
    send_file(path, :disposition => 'attachment')
  end
end