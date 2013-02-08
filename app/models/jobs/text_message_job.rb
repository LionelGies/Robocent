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

    body_content = text_message.content
    body_content = body_content.scan(/.{1,160}/)

    @queued_number = text_message.queue_texts.find(:first, :conditions => ["queue_texts.paused = ?", false])

    @success = false
    @error = nil

    while @queued_number.present?
      body_content.each do |body|
        response = TwilioRequest::send_message(from, @queued_number.phone_number, body)
        if response == "true"
          @success = true
          @error = nil
        else
          @success = false
          @error = response
        end
      end

      #update text message sending status
      text_message.total_processed = text_message.total_processed + 1
      text_message.succeeded = text_message.succeeded + 1 if @success == true
      text_message.succeeded_numbers = "#{text_message.succeeded_numbers}#{@queued_number.phone_number}," if @success == true
      text_message.failed_alerts = "#{text_message.failed_alerts}#{@error}," if @error.present?
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