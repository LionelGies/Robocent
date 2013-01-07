class SmsMessage < ActiveRecord::Base
  attr_accessible :body, :contact_id, :from, :from_city, :from_country, 
    :from_state, :from_zip, :sms_sid, :status, :to, :user_id

  belongs_to :user
  belongs_to :contact
end
