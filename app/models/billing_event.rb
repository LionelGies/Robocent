class BillingEvent < ActiveRecord::Base
  attr_accessible :event_type, :response, :user_id, :recurring

  belongs_to :user

  after_create :send_notification_email
  after_create :add_monthly_free_balance

  private

  def add_monthly_free_balance
    if self.event_type == "invoice.payment_succeeded" and self.user.subscription.plan.recurring
      payment = self.user.subscription.plan.monthly_free_credit
      r = Receipt.new(:memo => 'Monthly included credit', :credit => payment, :free => true)
      self.user.receipts << r
    end
  end

  def send_notification_email
    Notification.delay.charge_succeeded(self.id) if self.event_type == "charge.succeeded" and !self.recurring
    Notification.delay.charge_failed(self.id) if self.event_type == "charge.failed" and !self.recurring
    Notification.delay.recurring_payment(self.id) if self.event_type == "invoice.payment_succeeded" or self.event_type == "invoice.payment_failed"
  end
end
