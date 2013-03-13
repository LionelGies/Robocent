class AddTextMessagesApprovalToUsers < ActiveRecord::Migration
  def change
	add_column :users, :text_messages_approval, :string
  end
end
