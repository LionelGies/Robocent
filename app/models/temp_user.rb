class TempUser < ActiveRecord::Base
  attr_accessible :email, :name, :user_id

  validates :email, :format =>  { :with => /^[\w\.\+-]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/ }
end
