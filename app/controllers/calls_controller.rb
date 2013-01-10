class CallsController < ApplicationController
  before_filter :require_login

  layout "dashboard"

  def new
    @step = params["step"].present? ? params["step"] : "1"
    
    @recordings = current_user.recordings.order("created_at DESC")

  end  

end