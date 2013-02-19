class AddTrialColumnsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :trial_start, :datetime
    add_column :subscriptions, :trial_end, :datetime
  end
end
