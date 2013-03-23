class Plan < ActiveRecord::Base
  attr_accessible :stripe_id, :amount, :currency, :interval, :maximum_numbers,
    :minimum_numbers, :name, :price_per_call_or_text, :trial_period_days, 
    :free_credit, :monthly_free_credit, :default, :recurring, :max_keywords,
    :card_required

  has_many :subscriptions
  has_many :users, :through => :subscriptions

  scope :default_plan, where("plans.default = ?", true)

  def details
    "#{minimum_numbers}-#{maximum_numbers} Numbers, $#{amount/100}/#{interval.capitalize}, #{price_per_call_or_text}&cent;/Call or Text".html_safe
  end
  
  STRIPE_ID = %w[pay_as_you_go basic advance]

  before_create :create_stripe_plan

  def create_stripe_plan
    if stripe_plan.blank? and self.recurring
      begin
        Stripe::Plan.create(
          :id => stripe_id,
          :amount => amount,
          :currency => currency,
          :interval => interval,
          :name => name,
          :trial_period_days => trial_period_days)
        return true
      rescue Stripe::StripeError => e
        logger.error e.message
        return false
      end
    end
  end

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(self.stripe_id) rescue nil
  end
end
