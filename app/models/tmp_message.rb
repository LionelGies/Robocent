class TmpMessage < ActiveRecord::Base
  attr_accessible :content, :email, :name, :user_id

  validates :email, :format =>  { :with => /^[\w\.\+-]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/ }
  validates :content, :presence => true
end
