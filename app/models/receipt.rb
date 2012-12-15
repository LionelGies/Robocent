class Receipt < ActiveRecord::Base
  attr_accessible :credit, :current_balance, :debit, :free, :memo, :user_id

  belongs_to :user

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
