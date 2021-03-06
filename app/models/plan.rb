class Plan < ActiveRecord::Base
  attr_accessible :stripe_id, :amount, :currency, :interval, :maximum_numbers,
    :minimum_numbers, :name, :price_per_call_or_text, :trial_period_days, 
    :free_credit, :monthly_free_credit, :default, :recurring, :max_keywords,
    :card_required, :monthly_fee, :monthly_included_text_or_call, :free_text
    
  has_many :subscriptions
  has_many :users, :through => :subscriptions
  
  validates :stripe_id, :uniqueness => true, :presence => true

  scope :default_plan, where("plans.default = ?", true)
  scope :enabled, where(:disabled => false)

  def details
    "#{minimum_numbers}-#{maximum_numbers} Numbers, $#{amount/100}/#{interval.capitalize}, #{price_per_call_or_text}&cent;/Call or Text".html_safe
  end

  before_create :create_stripe_plan
  before_create :card_required_check
  
  def create_stripe_plan
    if stripe_plan.blank?
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

  def card_required_check
    self.card_required = true if self.amount > 0
  end
  
  #attr_accessor
  def monthly_fee=(fee)
    self.amount = (fee.to_f * 100).round
  end
  def monthly_fee
    "%.2f" % (self.amount.to_f/100)
  end
  
  def monthly_included_text_or_call=(text_or_call)
    self.monthly_free_credit = text_or_call.to_f * formated_price_per_call_text / 100
  end

  def monthly_included_text_or_call
    begin
      (self.monthly_free_credit.to_f / formated_price_per_call_text * 100).round
    rescue
      0 #if exception return 0. Divide by zero exception my raised
    end
  end
  
  def free_text=(free)
    self.free_credit = (formated_price_per_call_text * free.to_i / 100)
  end

  def free_text
    begin
      (self.free_credit.to_f / formated_price_per_call_text * 100).round
    rescue
      0 #if exception return 0. Divide by zore exeception my raised 
    end
  end
  
  def formated_price_per_call_text
    if self.price_per_call_or_text.blank?
      0.0
    else
      self.price_per_call_or_text
    end
  end
end
