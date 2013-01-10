class Recording < ActiveRecord::Base
  attr_accessible :duration, :sid, :title, :url, :user_id

  belongs_to :user
end
