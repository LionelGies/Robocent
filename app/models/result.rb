class Result < ActiveRecord::Base
  attr_accessible :call_dur, :call_id, :call_result, :call_start, :dial_dur,
    :dial_start, :on_time, :orderID, :pass, :phone
end
