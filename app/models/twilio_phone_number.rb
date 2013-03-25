class TwilioPhoneNumber < ActiveRecord::Base
  attr_accessible :area_code, :phone_number, :user_id, :pin_number, :sid

  belongs_to :user

  validates :phone_number, :presence => true

  before_create :buy_twilio_number
  after_create :issue_pin_number

  before_destroy :release_twilio_number

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
    number = TwilioRequest::buy_phone_number(phone_number)
    if number
      self.sid = number.sid
    else
      return false
    end
  end

  def release_twilio_number
    TwilioRequest::release_number(self.sid)
  end
end
