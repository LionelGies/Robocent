class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.integer :user_id
      t.float :debit,           :default => 0.0
      t.float :credit,          :default => 0.0
      t.float :current_balance, :default => 0.0
      t.string :memo
      t.boolean :free

      t.timestamps
    end
  end
end
