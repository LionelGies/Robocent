class UsersController < ApplicationController
  layout 'public'
  
  def new
    @step_id = params[:step_id]
    if session[:user_id].present?
      @user = User.find(session[:user_id])
    else
      @user = User.new
    end
  end

  def create
    @step_id = params[:step_id]

    if session[:user_id].present?
      @user = User.find(session[:user_id])
    else
      @user = User.new
    end

    if @step_id == "1"
      puts "Step 1"
      if @user.update_attributes(params[:user])
        session[:user_id] = @user.id
        @step_id = "2"
      end
    elsif @step_id == "2"
      #twilio integration
      @step_id = "3"
      puts "Step 2"
    elsif @step_id == "3"
      #stripe integration
      @step_id = "finish"
      puts "Step 3"
    end

    if @step_id == "finish"
      redirect_to register_confirmation_path
    else
      render :new
    end
  end

  def confirmation
    @user = User.find(session[:user_id]) if session[:user_id].present?
    session.delete(:user_id)
  end

  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      auto_login(@user)
      redirect_back_or_to root_path, :notice => "User was successfully activated."
    else
      flash[:notice] = "Looks like your account has already been activated.  Please login or request password help."
      not_authenticated
    end
  end
end
