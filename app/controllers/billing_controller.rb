class BillingController < ApplicationController
  before_filter :require_login

  layout 'dashboard'

  def index
    @current_balance = current_user.current_balance
    @subscribed_plan = current_user.subscription.plan
    @monthly_charge = @subscribed_plan.amount.to_f / 100.0
    @price_per_call_or_text = @subscribed_plan.price_per_call_or_text
    @total_call_can = (@current_balance / (@price_per_call_or_text / 100 )).to_i
    @billing_setting = current_user.billing_setting
    @funds = current_user.receipts.where({:free => nil, :debit => "0"})

    Time.zone = current_user.time_zone
    if params[:date_from].present? && params[:date_to].present?
      @date_from = Time.zone.parse(params[:date_from].to_date.to_s).beginning_of_day.utc
      @date_to = Time.zone.parse(params[:date_to].to_date.to_s).end_of_day.utc
    else
      @date_from = Time.zone.now.beginning_of_month.utc
      @date_to = Time.zone.now.end_of_day.utc
    end
    Time.zone = "UTC"

    @transactions = current_user.receipts.by_date_range(@date_from, @date_to).order("id desc")
    if @transactions.present?
      @beginning_balance = @transactions.last.current_balance - @transactions.last.credit + @transactions.last.debit
      @total_debits = @transactions.sum(:debit)
      @total_credits = @transactions.sum(:credit)
      @total_change = (@total_credits - @total_debits).abs
      @ending_balance = @transactions.first.current_balance
    end
  end

  def fund_account
    if current_user.billing_setting.charge(params[:amount], "Manually funded account")
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