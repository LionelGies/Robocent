class Subscription < ActiveRecord::Base
  attr_accessible :plan_id, :status, :user_id

  belongs_to :user
  belongs_to :plan

  before_create {|s| s.status = "pending"}

  def create_or_update_subscription
    user.billing_setting.customer.update_subscription(:plan => plan.stripe_id)
    self.save
  end

end
