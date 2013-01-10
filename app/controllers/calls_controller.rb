class CallsController < ApplicationController
  before_filter :require_login

  layout "dashboard"

  def new
    @step = params["step"].present? ? params["step"] : "1"

    puts session[:call].inspect

    @recordings = current_user.recordings.order("created_at DESC")

    if @step == "2" and session[:call].blank? and params[:call].blank?
      flash.now.alert = "Please Select at least one recording!"
      @step = "1"
    end

    if session[:call].present?
      session[:call] = session[:call].merge(params[:call]) if params[:call].present?
      @call = current_user.calls.new(session[:call])
    elsif params[:call].present?
      @call = current_user.calls.new(params[:call])
      session[:call] = params[:call]
    else
      @call = Call.new
    end

  end  

end