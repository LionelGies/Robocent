require 'uri'
require 'net/http'

class Jobs::CallJob < Struct.new(:call)

  def perform
    count = 0
    numbers = []
    call.lists.each do |list|
      numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
    end

    numbers.each do |number|
      call_queue = call.call_queues.new(
        :phone => number,
        :calleridname => call.user.name,
        :calleridnum => call.caller_id_number,
        :recordingname => call.recording.file_identifier)

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