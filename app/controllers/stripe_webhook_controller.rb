class StripeWebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    begin
      codes = %w(charge.succeeded charge.failed charge.refunded charge.dispute.created charge.dispute.updated charge.dispute.closed)
      if codes.include?(params["type"])
        billing_setting = BillingSetting.find_by_stripe_id(params["data"]["object"]["customer"])
        BillingEvent.create(
          :event_type     => params["type"],
          :user_id        => billing_setting.user.present? ? billing_setting.user_id : nil,
          :response => params["data"]
        )
      end
    rescue => e
      error = e
    end

    respond_to do |format|
      if error.blank?
        format.any { render :text => "SUCCESS", :status => :ok }
      else
        format.any { render :text => "ERROR", :status => :bad_request }
      end
    end
  end
end
