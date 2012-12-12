class CreateBillingSettings < ActiveRecord::Migration
  def change
    create_table :billing_settings do |t|
      t.integer :user_id
      t.string  :stripe_id
      t.string  :card_last_four_digits
      t.date    :card_expiry_date
      t.string  :card_type
      t.string  :card_holder_name

      t.timestamps
    end
  end
end
