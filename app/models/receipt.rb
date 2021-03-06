class Receipt < ActiveRecord::Base
  attr_accessible :credit, :current_balance, :debit, :free, :memo, :user_id,
    :stripe_charge_id

  belongs_to :user

  scope :by_date_range, lambda{ |*args| {:conditions => ["receipts.created_at BETWEEN ? AND ?", args.first, args.second]} }

  after_create :update_account_balance

  private

  def update_account_balance
    user.account_balance.with_lock do
      user.account_balance.current_balance += self.credit if !self.credit.zero?
      user.account_balance.current_balance -= self.debit if !self.debit.zero?
      user.account_balance.save!
      self.current_balance = user.account_balance.current_balance
      save!
    end
  end
end
