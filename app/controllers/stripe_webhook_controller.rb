class StripeWebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    params = {"type"=>"charge.succeeded", "pending_webhooks"=>2, "object"=>"event",
      "livemode"=>false, "created"=>1356191715,
      "id"=>"evt_0xqItMrYyP92a2",
      "data"=>{"object"=>{"refunded"=>false,
          "card"=>{"type"=>"Visa", "address_state"=>nil,
            "last4"=>"4242", "address_country"=>nil,
            "address_line1"=>nil, "fingerprint"=>"8kTyY0U8Bww2R197",
            "object"=>"card", "address_line2"=>nil, "cvc_check"=>"pass",
            "exp_month"=>12, "address_city"=>nil, "address_zip_check"=>nil,
            "exp_year"=>2012, "name"=>"Maruf hasan Bulbul",
            "country"=>"US", "address_zip"=>nil, "address_line1_check"=>nil},
          "dispute"=>nil, "fee_details"=>[{"type"=>"stripe_fee", "amount"=>31,
              "application"=>nil, "currency"=>"usd",
              "description"=>"Stripe processing fees"}],
          "fee"=>31, "failure_message"=>nil, "livemode"=>false,
          "customer"=>"cus_0vM2WQnfRh0Qbp", "created"=>1356191714,
          "object"=>"charge", "currency"=>"usd", "amount_refunded"=>0,
          "amount"=>50, "invoice"=>nil, "id"=>"ch_0xqIFGf2PqOG28",
          "description"=>"Manually fundded account.", "paid"=>true}},
      "stripe_webhook"=>{"type"=>"charge.succeeded", "pending_webhooks"=>2,
        "object"=>"event", "livemode"=>false, "created"=>1356191715,
        "id"=>"evt_0xqItMrYyP92a2", "data"=>{"object"=>{"refunded"=>false,
            "card"=>{"type"=>"Visa", "address_state"=>nil, "last4"=>"4242",
              "address_country"=>nil, "address_line1"=>nil,
              "fingerprint"=>"8kTyY0U8Bww2R197", "object"=>"card",
              "address_line2"=>nil, "cvc_check"=>"pass", "exp_month"=>12,
              "address_city"=>nil, "address_zip_check"=>nil,
              "exp_year"=>2012, "name"=>"Maruf hasan Bulbul",
              "country"=>"US", "address_zip"=>nil, "address_line1_check"=>nil},
            "dispute"=>nil, "fee_details"=>[{"type"=>"stripe_fee", "amount"=>31,
                "application"=>nil, "currency"=>"usd",
                "description"=>"Stripe processing fees"}],
            "fee"=>31, "failure_message"=>nil, "livemode"=>false,
            "customer"=>"cus_0vJyz1fQkQauF1",
            "created"=>1356191714, "object"=>"charge",
            "currency"=>"usd", "amount_refunded"=>0,
            "amount"=>50, "invoice"=>nil, "id"=>"ch_0xqIFGf2PqOG28",
            "description"=>"Manually fundded account.", "paid"=>true}}}}
    #begin
      types = %w(charge.succeeded charge.failed charge.refunded charge.dispute.created charge.dispute.updated charge.dispute.closed)
      puts params["type"]
      if types.include?(params["type"])
        puts params["type"]
        billing_setting = BillingSetting.find_by_stripe_id(params["data"]["object"]["customer"])
        puts billing_setting.inspect
        BillingEvent.create(
          :event_type     => params["type"],
          :user_id        => billing_setting.user.present? ? billing_setting.user_id : nil,
          :response => params["data"]["object"]
        )
      end
    #rescue => e
    #  error = e
    #end

    respond_to do |format|
     # if error.blank?
        format.any { render :text => "SUCCESS", :status => :ok }
    #  else
     #   format.any { render :text => "ERROR", :status => :bad_request }
     # end
    end
  end
end
