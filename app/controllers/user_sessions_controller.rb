class UserSessionsController < ApplicationController
  layout 'publics'

  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      if user.activation_state == "active"
        if user.twilio_phone_number.blank?
          logout
          session[:user_temp_id] = user.id
          redirect_to register_url(:step_id => "2"), :alert => "Please complete your registration to access your dashborad!"
        elsif user.billing_setting.blank?
          logout
          session[:user_temp_id] = user.id
          redirect_to register_url(:step_id => "3"), :alert => "Please complete your registration to access your dashboard!"
        else
          redirect_back_or_to dashboard_url, :notice => "Logged in!"
        end
      else
        logout
        flash.now.alert = "Please activate your account!"
        render :new
      end
    else
      flash.now.alert = "Email or password was invalid"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out!"
  end


end
