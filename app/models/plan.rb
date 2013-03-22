class Plan < ActiveRecord::Base
  attr_accessible :stripe_id, :amount, :currency, :interval, :maximum_numbers,
    :minimum_numbers, :name, :price_per_call_or_text, :trial_period_days, :free_credit, :monthly_free_credit

  has_many :subscriptions
  has_many :users, :through => :subscriptions

  def details
    "#{minimum_numbers}-#{maximum_numbers} Numbers, $#{amount/100}/#{interval.capitalize}, #{price_per_call_or_text}&cent;/Call or Text".html_safe
  end
  
  STRIPE_ID = %w[pay_as_you_go basic advance]
  
  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(self.stripe_id) rescue nil
  end

  before_create :create_stripe_plan #set condition check of 'basic', 'advance'
  #  before_save :update_stripe_plan
  #  before_destroy :delete_stripe_plan
  #
  def create_stripe_plan
    return if self.stripe_id == STRIPE_ID[0]
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
  #
  #  def update_stripe_plan
  #
  #  end
  #  def delete_stripe_plan
  #    
  #  end
end
