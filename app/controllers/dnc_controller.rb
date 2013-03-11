class DncController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource
  
  layout "dashboard"
  
  def index
    @dnc = current_user.dnc
  end

  def create
    @contact = Contact.find(params[:contact_id])
  	@dnc = current_user.dnc.new(:contact_id => @contact.id)
  	@dnc.phone = @contact.phone_number
    @dnc.save

  	respond_to do |format|
		  format.js
  	end
  end

  def destroy
    @dnc = Dnc.find(params[:id])
    @contact = @dnc.contact

    @dnc_list = true if params[:dnc_list].present?
    
    respond_to do |format|
      if @dnc.destroy
        @destroyed = true
      end
      format.js
    end
  end
end
