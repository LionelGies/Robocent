class BillingEvent < ActiveRecord::Base
  attr_accessible :event_type, :response, :user_id
end
