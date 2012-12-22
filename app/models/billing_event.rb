class BillingEvent < ActiveRecord::Base
  attr_accessible :event_type, :response, :user_id

  belongs_to :user

  after_create :send_notification_email


  def send_notification_email
    Notification.charge_succeeded(self).deliver if self.event_type == "charge.succeeded"
  end
end
