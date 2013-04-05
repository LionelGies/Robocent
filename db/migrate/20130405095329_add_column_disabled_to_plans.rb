class AddColumnDisabledToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :disabled, :boolean, :default => false
  end
end
