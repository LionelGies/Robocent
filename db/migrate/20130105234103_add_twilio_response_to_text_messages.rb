class AddTwilioResponseToTextMessages < ActiveRecord::Migration
  def change
    add_column :text_messages, :total_processed, :integer, :default => 0
    add_column :text_messages, :succeeded, :integer, :default => 0
    add_column :text_messages, :succeeded_numbers, :text
    add_column :text_messages, :failed_alerts, :text
  end
end
