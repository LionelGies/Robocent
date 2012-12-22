class BillingEvent < ActiveRecord::Base
  attr_accessible :event_type, :response, :user_id

  belongs_to :user

  after_create :send_notification_email


  private

  def send_notification_email
    Notification.charge_succeeded(self.id).deliver if self.event_type == "charge.succeeded"
    Notification.charge_failed(self.id).deliver if self.event_type == "charge.failed"
    Notification.recurring_payment(self.id).deliver if self.event_type == "invoice.payment_succeeded" or self.event_type == "invoice.payment_failed"
  end
end
