class CallQueue < ActiveRecord::Base
  set_table_name "call_queue"
  attr_accessible :calleridname, :calleridnum, :dialingserver, :order, :phone,
    :recordingname, :status

  belongs_to :call, :foreign_key => "order"
  
end
