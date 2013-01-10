class TwilioPhoneNumber < ActiveRecord::Base
  attr_accessible :area_code, :phone_number, :user_id, :pin_number

  belongs_to :user

  before_create :buy_twilio_number
  after_create :issue_pin_number

  def issue_pin_number
    begin
      r = Random.new
      pin = Random.rand(11...99).to_s + Random.rand(11...99).to_s + Random.rand(11...99).to_s
      tw = TwilioPhoneNumber.find_by_pin_number(pin)
    end while tw.present?
    self.pin_number = pin
    self.save
  end

  private

  def buy_twilio_number
    TwilioRequest::buy_phone_number(phone_number)
  end
end
