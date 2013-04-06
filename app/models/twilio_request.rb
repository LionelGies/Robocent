class TwilioRequest
  if Rails.env.development?
    @account_sid = 'AC9737c64cd9988bfdac3b059ed3f8a0f9' # test credentials
    @auth_token = 'f0a84c03212696b630283b6094925c33'    # test credentials
    #    @account_sid = 'AC3a4508e28fd700fd592959fc04e80d5a' # sub-account credentials
    #    @auth_token = '4c8079f7b4eab47683c1ae302075bb45'    # sub-account credentials
  elsif Rails.env.staging? or Rails.env.production?
    @account_sid = 'AC2ba64a6ec3824a9da645efee9f7346d4' # live credentials
    @auth_token = 'f88f86dd6b179379e4a00abedd1d970f'    # live credentials
  end

  @client = Twilio::REST::Client.new @account_sid, @auth_token
  @account = @client.account

  def self.sandbox
    @sandbox = @account.sandbox
  end

  def self.available_phone_numbers(area_code)
    @account_sid = 'AC2ba64a6ec3824a9da645efee9f7346d4' # live credentials
    @auth_token = 'f88f86dd6b179379e4a00abedd1d970f'    # live credentials
    @client = Twilio::REST::Client.new @account_sid, @auth_token
    @account = @client.account
    return @account.available_phone_numbers.get('US').local.list({
        :contains => "+1#{area_code}"
      })
  end

  def self.buy_phone_number(phone_number)
    begin
      application_sid = if Rails.env.production?
        "AP52acf39a4521e055a36e77163f996cc4"
      elsif Rails.env.staging?
        "APca63f28ef4513a21188f878fac3354d0"
      end
      return @account.incoming_phone_numbers.create({:phone_number => phone_number,
          :sms_application_sid => "#{application_sid}"}) if phone_number.present?
    rescue Twilio::REST::RequestError => e
      return false
    end
  end

  def self.send_message(from, to, body)
    begin
      r = []
      len = 160
      start = 0
      while(start <= body.length) do
        r << body[start...start+len]
        start += len
      end
      r.delete_if { |item| item.length == 0 }

      r.each do |s_body|
        @account.sms.messages.create(
          :from => from,
          :to => to,
          :body => s_body
        )
      end

      return "true"
    rescue Twilio::REST::RequestError => e
      return e.message
    end
  end

  def self.release_number(sid)
    begin
      @number = @account.incoming_phone_numbers.get(sid)
      @response = @number.delete
      return true
    rescue 
      return true
    end
  end
end