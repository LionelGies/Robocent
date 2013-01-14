class CallsController < ApplicationController
  before_filter :require_login

  layout "dashboard"

  def show
     @call = Call.find(params[:id])
    render :layout => false
  end

  def new
    @step = params["step"].present? ? params["step"] : "1"

    @recordings = current_user.recordings.where("file IS NOT NULL").order("created_at DESC")

    #    if @step == "2" and params[:recording].present? and params[:recording][:file].present?
    #      @recording = current_user.recordings.new(params[:recording])
    #      if @recording.save
    #        session[:call] = {} if session[:call].blank?
    #        session[:call]["recording_id"] = "#{@recording.id}"
    #        params[:call].delete("recording_id") if params[:call].present?
    #      end
    #    end
    
    if @step == "2" and session[:call].blank? and params[:call].blank?
      flash.now.alert = "Please Select at least one recording!"
      @step = "1"
    end

    if session[:call].present?
      session[:call] = session[:call].merge(params[:call]) if params[:call].present?

      if params[:list_ids].present? and params[:list_ids].size > 0
        session[:call] = session[:call].merge({:list_ids => params[:list_ids].join(",")})
      elsif @step == "3" and session[:call][:list_ids].blank?
        flash.now.alert = "Please Select at least one contact list!"
        @step = "2"
      end
      @call = current_user.calls.new(session[:call])
      
    elsif params[:call].present?
      @call = current_user.calls.new(params[:call])
      session[:call] = params[:call]
    else
      @call = Call.new
    end

    if @step == "4" and session[:call].present? and @call.present?
      begin
        numbers = []
        @call.lists.each do |list|
          numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
        end
        number_of_contacts = numbers.size
        cost_per_call = current_user.subscription.plan.price_per_call_or_text / 100.0
      
        new_hash = {
          :number_of_recipients => number_of_contacts,
          :cost_per_call => cost_per_call,
          :total_cost => number_of_contacts * cost_per_call
        }

        session[:call] = session[:call].merge(new_hash)
        @call = current_user.calls.new(session[:call])
      rescue => e
        puts e.message
        @step = "1"
      end
    end
    
    @current_balance = current_user.account_balance.current_balance
  end

  def create
    @call = current_user.calls.new(session[:call])
    #
    # convert schedule_at time user time zone to utc time zone
    require 'chronic'
    Time.zone = current_user.time_zone
    Chronic.time_class = Time.zone
    start_time_string = "#{session[:call]["schedule_at(1i)"]}-#{session[:call]["schedule_at(2i)"]}-#{session[:call]["schedule_at(3i)"]} at #{session[:call]["schedule_at(4i)"]}:#{session[:call]["schedule_at(5i)"]} #{session[:call]["schedule_at(7i)"]}"
    start_time = Chronic.parse(start_time_string)

    if start_time <= Time.now or session[:call][:schedule_now] == "1"
      start_time = Time.zone.now + 5.seconds
    end
    Time.zone = "UTC"

    @call.schedule_at = start_time.utc
    
    if @call.save
      session.delete(:call)
      redirect_to dashboard_path, :notice => "Successfully placed the call into queue!"
    else
      redirect_to send_call_path
    end
  end

  def send_test_call
    puts params.inspect
    render :js => ""
  end

end