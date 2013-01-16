require 'uri'
require 'net/http'

class Jobs::TextMessageJob < Struct.new(:text_message)

  def perform
    #from = text_message.user.twilio_phone_number.phone_number # if text_message.sending_option == 1
    #from = "47543" if text_message.sending_option != 1

    if(Rails.env == 'development')
      from = "+15005550006" #valid for Test
    elsif(Rails.env == 'production' or Rails.env == 'staging')
      from = text_message.user.twilio_phone_number.phone_number
    end
    successes = []
    errors = []
    count = 0
    numbers = []
    text_message.lists.each do |list|
      numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
    end

    body_content = text_message.content
    body_content = body_content.scan(/.{1,160}/)

    numbers.each do |number|
      body_content.each do |body|
        response = TwilioRequest::send_message(from, number, body)
        if response == "true"
          successes << "#{number}"
        else
          errors << response
        end
      end

      count += 1
      
      #update text message sending stats
      text_message.total_processed = count
      text_message.succeeded = successes.uniq.size
      text_message.succeeded_numbers = successes.uniq.join(",")
      text_message.failed_alerts = errors.uniq.join(",")
      text_message.save
    end
  end

  def before(job)
    text_message.started_at = Time.zone.now
    text_message.save
  end

  def after(job)
    text_message.finished_at = Time.zone.now
    text_message.save
  end

  def failure(job)
    text_message.finished_at = Time.zone.now
    text_message.save
  end
end