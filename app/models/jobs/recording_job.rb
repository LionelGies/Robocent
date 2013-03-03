require 'uri'
require 'net/http'

class Jobs::RecordingJob < Struct.new(:recording)

  def perform
    #download recording from twilio
    if recording.url.present? and recording.file.blank?
      recording.remote_file_url = "#{recording.url}.mp3"
      recording.save
      Notification.recording_succeeded(recording).deliver
    end

    #convert recording to wav and upload to ftp server
    recording.upload_to_ftp

    if recording.duration.blank?
      recording.update_length
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