class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create, :confirmation, :activate, :twilionumbers]
  require 'twilio-ruby'

  def new
    @step_id = params[:step_id]
    if session[:user_temp_id].present?
      @user = User.find(session[:user_temp_id])
    else
      @user = User.new
    end
  end

  def create    
    @user = User.new(params[:user])
    
    if @user.save
      find_plan(params[:pricing_plan])
      BillingSetting.create(:user_id => @user.id)
      Subscription.create(:user_id => @user.id, :plan_id => @plan.id)
      auto_login @user
      redirect_to dashboard_path
    else
      render :action => :new
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      auto_login(@user)
      redirect_back_or_to dashboard_url, :notice => "User was successfully activated."
    else
      flash[:notice] = "Looks like your account has already been activated.  Please login or request password help."
      redirect_to root_path
    end
  end

  def twilionumbers
    @area_code = params[:code]
    begin
      @numbers = TwilioRequest::available_phone_numbers(params[:code]).collect{|n| [n.phone_number]}
    rescue => e
     @error = e.message
    end
  end

  def update_password
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to profile_path, :notice => "Your password has been updated"
    else
      @alert = @user.errors.present? ? @user.errors.full_messages.first : "Something went wrong!"
      redirect_to profile_path, :alert => @alert
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to profile_path, :notice => "Your profile has been updated"
    else
      redirect_to profile_path, :alert => "Something went wrong! Please try again."
    end
  end
  
  private
  def find_plan(stripe_id)
    @plan = Plan.find_by_stripe_id stripe_id
    @plan = Plan.default_plan.first unless @plan
    @plan
  end
end
