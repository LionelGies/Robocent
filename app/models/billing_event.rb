class BillingEvent < ActiveRecord::Base
  attr_accessible :event_type, :response, :user_id

  belongs_to :user
end
