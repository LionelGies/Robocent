class ImportsController < ApplicationController
  before_filter :require_login
  
  def create
    @import = current_user.imports.new(params[:import])

    if @import.save
      redirect_to new_contact_path, :notice => "Successfully Uploaded!"
    else
      redirect_to new_contact_path, :notice => "Something went Wrong!!"
    end
  end
end