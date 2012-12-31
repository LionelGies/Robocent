class AddListIdsToTextMessages < ActiveRecord::Migration
  def change
    remove_column :text_messages, :list_id
    add_column :text_messages, :list_ids, :string
  end
end
