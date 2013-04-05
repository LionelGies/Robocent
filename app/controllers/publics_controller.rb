class PublicsController < ApplicationController
  def index
    @plans = Plan.enabled.order(:amount)
    redirect_to dashboard_path if current_user.present?
  end

  def solutions
    @plans = Plan.enabled.order(:amount)
  end

  def contact
    @contact_us = TmpMessage.new
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

  def privacy_policy
  end

  def terms
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

  def residential_communities
    render :layout => false
  end

end
