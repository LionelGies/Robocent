class AddStripeChargeIdToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :stripe_charge_id, :string
  end
end
