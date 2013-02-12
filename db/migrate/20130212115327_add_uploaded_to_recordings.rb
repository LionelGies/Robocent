class AddUploadedToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :uploaded, :boolean, :default => false
  end
end
