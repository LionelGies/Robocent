class Subscription < ActiveRecord::Base
  attr_accessible :plan_id, :status, :user_id

  belongs_to :user
  belongs_to :plan

  before_create :set_trial

  after_create :add_free_balance
  after_create :create_stripe_subscription

  before_destroy :deactivate_stripe_subscription

  def set_trial
    if plan.trial_period_days.present?
      self.trial_start = Time.now
      self.trial_end = Time.now + self.plan.trial_period_days.to_i.days
      self.status = "trailing"
    end
  end

  def trial
    Time.now < self.trial_end ? true : false
  end

  def create_stripe_subscription
    subscription = user.billing_setting.customer.update_subscription(:plan => plan.stripe_id)
    self.status = subscription.status if subscription.status.present?
    self.trial_start = Time.at(subscription.trial_start) if subscription.trial_start.present?
    self.trial_end = Time.at(subscription.trial_end) if subscription.trial_end.present?
    self.save
  end

  def migrate(new_plan)
    if new_plan.amount >= self.plan.amount
      # Upgrade
      user.billing_setting.customer.update_subscription(:plan => new_plan.stripe_id,
        :prorate => true)
      self.plan_id = new_plan.id
      self.status = "pending"
      self.save!
      if !new_plan.recurring
        user.twilio_phone_number.destroy
      end
    else
      # Downgrade
      user.billing_setting.customer.update_subscription(:plan => new_plan.stripe_id,
        :prorate => false)
      schedule_at = Time.at(user.billing_setting.customer.subscription.current_period_end).utc
      user.build_plan_migration(:new_plan_id => new_plan.id,
        :schedule_at => schedule_at)
      user.plan_migration.save
    end
  end

  def deactivate_stripe_subscription
    begin
      user.billing_setting.customer.cancel_subscription
    rescue
      return true
    end
  end

  def add_free_balance
    payment = self.plan.free_credit
    r = Receipt.new(:memo => 'New account free balance', :credit => payment, :free => true)
    self.user.receipts << r
  end

end
