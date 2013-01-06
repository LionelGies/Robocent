class AddJobStatusToTextMessages < ActiveRecord::Migration
  def change
    add_column :text_messages, :started_at, :datetime
    add_column :text_messages, :finished_at, :datetime
  end
end
