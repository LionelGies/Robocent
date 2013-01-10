class Call < ActiveRecord::Base
  attr_accessor :schedule_now
  attr_accessible :caller_id_number, :cost_per_call, :list_ids,
    :number_of_recipients, :recording_id, :schedule_at, :test_send_to,
    :total_cost, :user_id, :schedule_now

  belongs_to :user

  def lists
    List.find(:all, :conditions => ["id in (?)", list_ids.split(",")])
  end
end
