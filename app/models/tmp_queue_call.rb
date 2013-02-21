class TmpQueueCall < ActiveRecord::Base
  attr_accessible :call_id, :phone_number

  belongs_to :call
end
