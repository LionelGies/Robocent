class BillingSetting < ActiveRecord::Base
  attr_accessible :card_expiry_date, :card_last_four_digits, :card_type, :stripe_id, :user_id,
    :stripe_token, :card_exp_month, :card_exp_year, :card_holder_name, :subscription_plan_id

  attr_accessor :stripe_token, :card_exp_month, :card_exp_year, :subscription_plan_id

  belongs_to :user

  before_save :set_card_expiry_date
  before_save :create_or_update_stripe_customer

  def set_card_expiry_date
    if self.card_exp_month.present? && self.card_exp_year.present?
      exp_date = "#{self.card_exp_year}-#{self.card_exp_month}-01"
      self.card_expiry_date = Date.parse(exp_date).end_of_month
    end
  end

  def create_or_update_stripe_customer

    if stripe_token.present?
      
      if stripe_id.nil?
        customer = Stripe::Customer.create(
          :description => self.user.name,
          :email => self.user.email,
          :card => stripe_token
        )
        self.card_last_four_digits = customer.active_card.last4
        self.stripe_id = customer.id

      else
        customer = Stripe::Customer.retrieve(stripe_id)
        customer.card = stripe_token
        customer.save
        self.card_last_four_digits = customer.active_card.last4
      end

      self.stripe_token = nil
    end
    
  end

end
