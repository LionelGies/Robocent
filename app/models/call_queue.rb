class CallQueue < ActiveRecord::Base
  self.table_name = 'call_queue'
  attr_accessible :calleridname, :calleridnum, :dialingserver, :order, :phone,
    :recordingname, :status

  belongs_to :call, :foreign_key => "order"
  has_one :result, :foreign_key => "call_id"
end
