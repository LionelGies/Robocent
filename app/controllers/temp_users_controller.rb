class TempUsersController < ApplicationController

  def new
    @temp_user = TempUser.new
  end

  def create
    @temp_user = TempUser.new(params[:temp_user])
    respond_to do |format|
      if @temp_user.save
        format.html { redirect_to root_path, :alert => "Successfully submitted your email!" }
        format.js
      else
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

end