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

  before_create :charge_difference
  after_create :create_receipt

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
end
