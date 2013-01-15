class TestCall < ActiveRecord::Base
  attr_accessible :calleridname, :calleridnum, :dialingserver, :phone,
    :recordingname, :status, :userID

  validates :phone, :presence => true

  belongs_to :user, :foreign_key => "userID"
end
