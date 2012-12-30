class TextMessage < ActiveRecord::Base
  attr_accessible :content, :list_id, :sending_option, :test_send_to, :user_id,
    :number_of_recipients, :cost_per_text, :number_of_texts_required, :total_cost

  belongs_to :user
  belongs_to :list

  validates :content,         :presence => true
  validates :list_id,         :presence => true
  validates :sending_option,  :presence => true
  validates :user_id,         :presence => true

  before_create :charge_difference
  after_create :create_receipt

  private

  def charge_difference
    if user.account_balance.current_balance < total_cost
      charge_difference = ((total_cost - user.account_balance.current_balance) * 100).ceil.to_f / 100.0
      user.billing_setting.charge(charge_difference, "Automatically fundded account")
    end
  end

  def create_receipt
    r = Receipt.new(:memo => "To send #{number_of_texts_required} text messages", :debit => total_cost)
    user.receipts << r
  end
end
