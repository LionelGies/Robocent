class Call < ActiveRecord::Base
  attr_accessor :schedule_now
  attr_accessible :caller_id_number, :cost_per_call, :list_ids,
    :number_of_recipients, :recording_id, :schedule_at, :test_send_to,
    :total_cost, :user_id, :schedule_now

  validates :user_id,   :presence => true
  validates :recording_id,   :presence => true
  validates :list_ids,   :presence => true

  belongs_to :user
  belongs_to :recording
  has_many :call_queues, :dependent => :destroy, :foreign_key => "order"
  has_many :results, :dependent => :destroy, :foreign_key => "orderID"

  before_create :charge_difference
  after_create :create_receipt
  after_create :send_call_to_queue

  def lists
    List.find(:all, :conditions => ["id in (?)", list_ids.split(",")])
  end

  def percent_completed
    # ((succeeded.to_f / number_of_recipients.to_f) * 100.0).to_i
    0
  end

  private

  def charge_difference
    if user.account_balance.current_balance < total_cost
      charge_difference = ((total_cost - user.account_balance.current_balance) * 100).ceil.to_f / 100.0
      charge_difference = 0.5 if charge_difference < 0.5
      user.billing_setting.charge(charge_difference, "Automatically fundded account")
    end
  end

  def create_receipt
    r = Receipt.new(:memo => "Call to #{number_of_recipients} contacts", :debit => total_cost)
    user.receipts << r
  end

  def send_call_to_queue
    delay_time = ((Time.parse(self.schedule_at.to_s) - Time.parse((DateTime.now).to_s))).to_i
    delay_time = 5 if delay_time < 5
    Delayed::Job.enqueue Jobs::CallJob.new(self), 0 , delay_time.seconds.from_now, :queue => "call"
  end
end
