class Recording < ActiveRecord::Base
  require "mp3info"
  require 'net/ftp'
  
  attr_accessible :sid, :title, :url, :file, :userID, :duration, :remote_file_url, :uploaded

  belongs_to :user, :foreign_key => "userID"
  has_many :call

  mount_uploader :file, MediaFileUploader

  after_create :update_length, :if => Proc.new{ self.duration.blank? }
  after_create :download_and_save, :if => Proc.new{ self.url.present? and self.file.blank? }
  after_save :upload_to_ftp, :if => Proc.new{ self.file.present? and self.uploaded == false }

  validate :file_or_url

  def file_or_url
    if file.blank? and url.blank?
      errors.add(:file, "File must be attached to upload!")
    end
  end

  def upload_to_ftp
    if self.file.present? and self.uploaded == false
      begin
        new_file_name = "#{self.file_identifier.gsub(".mp3", "").gsub(".wav", "")}.wav"
        system "sox #{Rails.root}/public#{self.file_url} -r 8000 -c 1 --guard #{Rails.root}/public/recordings/#{new_file_name}"
          
        path = "#{Rails.root}/public/recordings/#{new_file_name}"

        url = "68.71.38.138"
        username = "ftprobocent"
        password = "ftprobocent9865"

        Net::FTP.open(url) do |ftp|
          ftp.passive = true
          ftp.login(username, password)
          ftp.storbinary("STOR #{new_file_name}", open(path, 'rb'), Net::FTP::DEFAULT_BLOCKSIZE)
        end
    
        self.uploaded = true
        self.save
      rescue
        self.uploaded = false
        self.save
        logger.info "Recording #{self.id} was not uploaded to ftp!"
      end
    end
  end

  def download_and_save
    self.remote_file_url = "#{self.url}.mp3"
    self.save
    Notification.recording_succeeded(self).deliver
  end

  handle_asynchronously :download_and_save

  def update_length
    info = []
    Mp3Info.open(self.file.path) do |mp3info|
      info << mp3info
    end
    info_str = info.first.to_s
    index = info_str.index("length")
    length = info_str[(index + 7)..(index+10)]
    self.duration = length
    self.save
  end
end
