class AddReadToSmsMessages < ActiveRecord::Migration
  def change
    add_column :sms_messages, :read, :boolean, :default => false
    add_column :sms_messages, :replied_to_id, :integer
  end
end
