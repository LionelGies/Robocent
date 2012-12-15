class AccountBalance < ActiveRecord::Base
  attr_accessible :current_balance, :user_id

  belongs_to :user
end
