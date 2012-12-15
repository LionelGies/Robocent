class CreateAccountBalances < ActiveRecord::Migration
  def change
    create_table :account_balances do |t|
      t.integer :user_id
      t.float :current_balance, :default => 0.0

      t.timestamps
    end
  end
end
