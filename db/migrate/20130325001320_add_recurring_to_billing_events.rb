class AddRecurringToBillingEvents < ActiveRecord::Migration
  def change
    add_column :billing_events, :recurring, :boolean, :default => 0
  end
end
