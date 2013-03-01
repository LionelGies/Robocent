class DncController < ApplicationController
  def create
  	p params[:dnc]
  	@dnc = current_user.dnc.new(params[:dnc])
  	@dnc.phone = formatted_number(params[:dnc][:phone])
  	
  	respond_to do |format|
	    if @dnc.save
		    format.js
	    else   
		    format.js
	    end
  	end  	
  end

  def destroy

  end
end
