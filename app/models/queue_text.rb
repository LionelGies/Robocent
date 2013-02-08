class QueueText < ActiveRecord::Base
  attr_accessible :phone_number, :text_message_id, :paused

  belongs_to :text_message
end
