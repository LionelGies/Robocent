class TextMessage < ActiveRecord::Base
  attr_accessor :schedule_now
  attr_accessible :content, :list_ids, :sending_option, :test_send_to, :user_id,
    :number_of_recipients, :cost_per_text, :number_of_texts_required, :total_cost,
    :schedule_at, :schedule_now

  belongs_to :user

  validates :content,         :presence => true
  validates :list_ids,        :presence => true
  validates :sending_option,  :presence => true
  validates :user_id,         :presence => true

  before_create :charge_difference
  after_create :create_receipt
  after_create :send_text_to_recipients

  def lists
    List.find(:all, :conditions => ["id in (?)", list_ids.split(",")])
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
    r = Receipt.new(:memo => "To send #{number_of_texts_required} text messages", :debit => total_cost)
    user.receipts << r
  end

  def send_text_to_recipients
    
  end
end
