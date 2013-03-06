class DncController < ApplicationController
  def create  	
  	@dnc = current_user.dnc.new(params[:dnc])
  	@dnc.phone = formatted_number(params[:dnc][:phone])
  	
  	respond_to do |format|
	    @dnc.save
		  format.js
  	end  	
  end

  def destroy
    @dnc = current_user.dnc.find_by_phone(formatted_number(params[:id]))
    respond_to do |format|
      if @dnc.blank? or @dnc.destroy
        @destroyed = true
      end
      format.js
    end
  end
end
