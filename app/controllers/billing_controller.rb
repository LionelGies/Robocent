class BillingController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  def index
    @current_balance = current_user.current_balance
    @subscribed_plan = current_user.subscription.plan
    @price_per_call_or_text = @subscribed_plan.price_per_call_or_text
    @total_call_can = (@current_balance / (@price_per_call_or_text / 100 )).to_i
    @billing_setting = current_user.billing_setting
  end

  def fund_account
    if current_user.billing_setting.charge(params[:amount])
      @current_balance = current_user.current_balance
      @price_per_call_or_text = current_user.subscription.plan.price_per_call_or_text
      @total_call_can = (@current_balance / (@price_per_call_or_text / 100 )).to_i
    end
  end

  def edit
    @billing_setting = BillingSetting.find(params[:id])
    render :layout => false
  end

  def update
    begin
      @billing_setting = current_user.billing_setting
      @billing_setting.update_attributes(params[:billing_setting])
      redirect_to billing_path, :notice => "Successfully updated your billing information"
    rescue Stripe::StripeError => e
      logger.error e.message
      redirect_to billing_path, :alert => e.message
    end
  end
end