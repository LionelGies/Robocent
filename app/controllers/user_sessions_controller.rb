class UserSessionsController < ApplicationController
  layout 'public'

  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      if user.activation_state == "active"
        redirect_back_or_to dashboard_url, :notice => "Logged in!"
      else
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
