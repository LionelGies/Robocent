class TwilioRequest
  @account_sid = 'AC2ba64a6ec3824a9da645efee9f7346d4' # test credentials
  @auth_token = 'f88f86dd6b179379e4a00abedd1d970f'    # test credentials
  @client = Twilio::REST::Client.new @account_sid, @auth_token
  @account = @client.account

  def self.available_phone_numbers(area_code)
    return @account.available_phone_numbers.get('US').local.list({
      :contains => "+#{area_code}"
      })
  end

  def self.buy_phone_number(area_code, phone_number)
    return @account.incoming_phone_numbers.create({:area_code => area_code}) if area_code.present?
    return @account.incoming_phone_numbers.create({:phone_number => phone_number}) if phone_number.present?
  end
end