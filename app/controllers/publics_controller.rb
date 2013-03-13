class PublicsController < ApplicationController
  layout "application"

  def index
    redirect_to dashboard_path if current_user.present?
  end

  def solutions
  end

  def pricing
  end

  def support
  end

  def faq
  end

  def tutorials
  end

  def guide
  end

  def contact
    @contact_us = TmpMessage.new
  end

  def terms
  end

  def contact_us_submit
    @contact_us = TmpMessage.new(params[:tmp_message])
    if @contact_us.save
      Notification.delay.contact_us_submit(@contact_us)
    end
    respond_to do |format|
      format.js
      format.html {redirect_to contact_path}
    end
    
  end

  def sms_terms
  end

  def sms_privacy
  end

  def promo_email
    render :layout => false
  end

  def email_code
    render :layout => false
  end

  def privacy_policy
    
  end

  def about

  end

end
