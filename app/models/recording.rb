class Recording < ActiveRecord::Base
  require "mp3info"
  
  attr_accessible :sid, :title, :url, :user_id, :file, :userID, :duration, :remote_file_url

  belongs_to :user, :foreign_key => "userID"
  has_many :call

  mount_uploader :file, MediaFileUploader

  after_create :update_length, :if => Proc.new{ self.duration.blank? }
  after_create :download_and_save, :if => Proc.new{ self.url.present? and self.file.blank? }
  after_create :convert_media, :if => Proc.new{ self.file.present? }

  validate :file_or_url

  def file_or_url
    if file.blank? and url.blank?
      errors.add(:file, "File must be attached to upload!")
    end
  end

  def convert_media
    system "sox #{Rails.root}/public/uploads/recordings/#{self.file_identifier} -r 8000 -c 1 #{Rails.root}/public/recordings/#{self.file_identifier.gsub(".mp3", "")}.wav"
  end

  def download_and_save
    self.remote_file_url = "#{self.url}.mp3"
    self.save
    system "sox #{Rails.root}/public/uploads/recordings/#{self.file_identifier} -r 8000 -c 1 #{Rails.root}/public/recordings/#{self.file_identifier.gsub(".mp3", "")}.wav"
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
