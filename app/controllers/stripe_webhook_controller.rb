class StripeWebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    begin
      types = %w(charge.succeeded charge.failed charge.refunded charge.dispute.created charge.dispute.updated charge.dispute.closed)
      invoice_types = %w(invoice.payment_succeeded invoice.payment_failed)
      if types.include?(params["type"]) or (invoice_types.include?(params["type"]) and params['data']['object']['total'] != 0)
        billing_setting = BillingSetting.find_by_stripe_id(params["data"]["object"]["customer"])
        BillingEvent.create(
          :event_type     => params["type"],
          :user_id        => billing_setting.user.present? ? billing_setting.user_id : nil,
          :response => params["data"]["object"]
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
