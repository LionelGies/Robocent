class AddFileToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :userID, :integer
    add_column :recordings, :file, :string
    add_column :recordings, :file_length, :string
    remove_column :recordings, :user_id
  end
end
