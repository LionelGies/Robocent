class DelayedJob < ActiveRecord::Base
  belongs_to :text_message
  attr_accessible :text_message_id
end