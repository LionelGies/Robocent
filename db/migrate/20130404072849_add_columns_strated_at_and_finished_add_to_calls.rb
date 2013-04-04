class AddColumnsStratedAtAndFinishedAddToCalls < ActiveRecord::Migration
  def change
    add_column :calls, :started_at, :datetime
    add_column :calls, :finished_at, :datetime
  end
end
