require 'uri'
require 'net/http'

class Jobs::CallJob < Struct.new(:call)

  def perform
    if call.recording.uploaded == false and call.recording.file.present?
      call.recording.upload_to_ftp
    end

    count = 0
    #    numbers = []
    #    call.lists.each do |list|
    #      numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
    #    end

    call.tmp_queue_calls.each do |q|
      call_queue = call.call_queues.new(
        :phone => q.phone_number.to_s.gsub(/\D/, ''),
        :calleridname => call.caller_id_number,
        :calleridnum => call.caller_id_number,
        :recordingname => call.recording.file_identifier.gsub(".mp3", ""))

      count += 1 if call_queue.save
    end
  end

  #  def before(job)
  #    call.started_at = Time.zone.now
  #    call.save
  #  end
  #
  #  def after(job)
  #    call.finished_at = Time.zone.now
  #    call.save
  #  end
  #
  #  def failure(job)
  #    call.finished_at = Time.zone.now
  #    call.save
  #  end
end