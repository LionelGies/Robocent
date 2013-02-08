class AddStatusToTextMessages < ActiveRecord::Migration
  def change
    add_column :text_messages, :status, :string
  end
end
