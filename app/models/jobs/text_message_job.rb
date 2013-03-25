require 'uri'
require 'net/http'

class Jobs::TextMessageJob < Struct.new(:text_message)

  def perform
    if(Rails.env == 'development')
      from = "+15005550006" #valid for Test
    else
      shortcode = ShortCode.first
      if text_message.sending_option == 1 and text_message.user.twilio_phone_number.present?
        from = text_message.user.twilio_phone_number.phone_number
      elsif shortcode.present?
        from = shortcode.number
      end
    end

    @queued_number = text_message.queue_texts.find(:first, :conditions => ["queue_texts.paused = ?", false])

    while @queued_number.present?
      
      response = TwilioRequest::send_message(from, @queued_number.phone_number, text_message.content)

      #update text message sending status
      text_message.total_processed = text_message.total_processed + 1

      if response == "true"
        text_message.succeeded = text_message.succeeded + 1
        text_message.succeeded_numbers = "#{text_message.succeeded_numbers}#{@queued_number.phone_number},"
      else
        text_message.failed_alerts = "#{text_message.failed_alerts}#{response},"
      end
      
      text_message.save

      @queued_number.destroy

      @queued_number = text_message.queue_texts.find(:first, :conditions => ["queue_texts.paused = ?", false])
    end
    
  end

  def before(job)
    text_message.status = "started"
    text_message.started_at = Time.zone.now
    text_message.save
  end

  def after(job)
    text_message.status = text_message.queue_texts.present? ? "paused" : "finished"
    text_message.finished_at = Time.zone.now
    text_message.save
  end

  def failure(job)
    text_message.status = text_message.queue_texts.present? ? "paused" : "finished"
    text_message.finished_at = Time.zone.now
    text_message.save
  end
end