require 'uri'
require 'net/http'

class Jobs::TextMessageJob < Struct.new(:text_message)

  def perform
    #from = text_message.user.twilio_phone_number.phone_number # if text_message.sending_option == 1
    #from = "47543" if text_message.sending_option != 1

    from = "+15005550006" #valid for Test

    successes = []
    errors = []
    count = 0
    numbers = []
    text_message.lists.each do |list|
      numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
    end

    numbers.each do |number|
      begin
        TwilioRequest::send_message(from, number, text_message.content)
        successes << "#{number}"
      rescue Exception => e
        errors << e.to_s
      end
      count += 1
    end

    text_message.total_processed = count
    text_message.succeeded = successes.size
    text_message.succeeded_numbers = successes.join(",")
    text_message.failed_alerts = errors.join(",")
    text_message.save
  end
end