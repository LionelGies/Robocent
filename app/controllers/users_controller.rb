class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create, :confirmation, :activate, :twilionumbers]
  require 'twilio-ruby'
  layout 'publics'
  
  def new
    @step_id = params[:step_id]
    if session[:user_temp_id].present?
      @user = User.find(session[:user_temp_id])
    else
      @user = User.new
    end
  end

  def create
    @step_id = params[:step_id]

    if session[:user_temp_id].present?
      @user = User.find(session[:user_temp_id])
    else
      @user = User.new
    end

    if @step_id == "1"
      # create or update user
      if @user.update_attributes(params[:user])
        session[:user_temp_id] = @user.id
        @step_id = "2"
      end
      
    elsif @step_id == "2"
      #twilio integration
      
      if session[:user_temp_id].present? && @user.present?
        if @user.twilio_phone_number.blank?
          @twilio_phone_number = @user.build_twilio_phone_number(params[:twilio_phone_number])
          @twilio_phone_number.save
        end
        @step_id = "3"
      else
        @step_id = "1"
      end

    elsif @step_id == "3"
      # save billing setting with stripe
      if session[:user_temp_id].present? && @user.present?
        @billing_setting = @user.build_billing_setting(params[:billing_setting])
        @billing_setting.save
        @subscription = @user.build_subscription(:plan_id => params[:billing_setting][:plan_id])
        @subscription.create_or_update_subscription
        @step_id = "finish"
      else
        @step_id = "1"
      end
    end

    if @step_id == "finish"
      redirect_to register_confirmation_path
    else
      render :new
    end

  rescue Stripe::StripeError => e
    logger.error e.message
    @user.errors.add :base, e.message
    render :action => :new
  end

  def confirmation
    @user = User.find(session[:user_temp_id]) if session[:user_temp_id].present?
    session.delete(:user_temp_id)
    if @user.present? and @user.activation_state == "active"
      redirect_to login_path
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      if @user.twilio_phone_number.blank?
        session[:user_temp_id] = @user.id
        redirect_to register_url(:step_id => "2"), :alert => "Please complete your registration to access your dashboard!"
      elsif @user.billing_setting.blank?
        session[:user_temp_id] = @user.id
        redirect_to register_url(:step_id => "3"), :alert => "Please complete your registration to access your dashboard!"
      else
        auto_login(@user)
        redirect_back_or_to dashboard_url, :notice => "User was successfully activated."
      end
    else
      flash[:notice] = "Looks like your account has already been activated.  Please login or request password help."
      not_authenticated
    end
  end

  def twilionumbers
    @area_code = params[:code]
    @numbers = TwilioRequest::available_phone_numbers(params[:code]).collect{|n| [n.phone_number]}
  end

  def update_password
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to profile_path, :notice => "Your password has been updated"
    else
      redirect_to profile_path, :alert => "Password doesn't match confirmation!"
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
end
