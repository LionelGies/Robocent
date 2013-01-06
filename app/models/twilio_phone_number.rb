class TwilioPhoneNumber < ActiveRecord::Base
  attr_accessible :area_code, :phone_number, :user_id

  belongs_to :user

  before_create :buy_twilio_number

  private

  def buy_twilio_number
    TwilioRequest::buy_phone_number(phone_number)
  end
end
