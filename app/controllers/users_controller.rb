class UsersController < ApplicationController
  layout 'public'
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end

  def confirmation
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
