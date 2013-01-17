class TempUsersController < ApplicationController
  layout 'publics'

  def new
    @temp_user = TempUser.new
  end

  def create
    @temp_user = TempUser.new(params[:temp_user])
    respond_to do |format|
      if @temp_user.save
        format.html { redirect_to register_path, :alert => "Successfully submitted your email!" }
        format.js
      else
        format.html { render :action => :new }
        format.js
      end
    end
  end

end