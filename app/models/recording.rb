class Recording < ActiveRecord::Base
  require "mp3info"
  require 'net/ftp'
  
  attr_accessible :sid, :title, :url, :file, :userID, :duration, :remote_file_url, :uploaded

  belongs_to :user, :foreign_key => "userID"
  has_many :call

  mount_uploader :file, MediaFileUploader

  after_create :process_recording
  
  validate :file_or_url

  def file_or_url
    if file.blank? and url.blank?
      errors.add(:file, "File must be attached to upload!")
    end
  end

  def process_recording
    delay_time = 2
    Delayed::Job.enqueue Jobs::RecordingJob.new(self), :priority => 0 , :run_at => delay_time.seconds.from_now, :queue => "new_recording"
  end

  def upload_to_ftp
    if self.file.present? and self.uploaded == false
      begin
        new_file_name = "#{self.file_identifier.gsub(".mp3", "").gsub(".wav", "")}.wav"
        system "sox #{Rails.root}/public#{self.file_url} -r 8000 -c 1 --guard #{Rails.root}/public/recordings/#{new_file_name}"
          
        path = "#{Rails.root}/public/recordings/#{new_file_name}"

        (1..3).each do |i|
          url = "192.95.8.6#{i}"
          username = "ftprobocent"
          password = "ftprobocent9865"

          Net::FTP.open(url) do |ftp|
            #ftp.passive = true
            ftp.login(username, password)
            ftp.storbinary("STOR #{new_file_name}", open(path, 'rb'), Net::FTP::DEFAULT_BLOCKSIZE)
          end
        end
    
        self.uploaded = true
        self.save
      rescue => error
        self.uploaded = false
        self.save
        logger.info "Recording #{self.id} was not uploaded to ftp!"
        logger.info error.backtrace
      end
    end
  end

  def update_length
    if self.file_identifier.include? ".mp3"
      info = []
      Mp3Info.open(self.file.path) do |mp3info|
        info << mp3info
      end
      info_str = info.first.to_s
      index = info_str.index("length")
      length = info_str[(index + 7)..(index+10)]
      self.duration = length
      self.save
    elsif self.file_identifier.include? ".wav"
      d = %x(soxi -D #{Rails.root}/public#{self.file_url})
      self.duration = d.to_f.ceil
      self.save
    end
  end
end
