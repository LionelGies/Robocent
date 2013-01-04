class AddScheduleAtToTextMessages < ActiveRecord::Migration
  def change
    add_column :text_messages, :schedule_at, :datetime
  end
end
