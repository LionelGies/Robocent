class TwilioPhoneNumber < ActiveRecord::Base
  attr_accessible :area_code, :phone_number, :user_id

  belongs_to :user
end
