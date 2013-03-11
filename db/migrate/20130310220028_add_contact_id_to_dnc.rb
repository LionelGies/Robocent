class AddContactIdToDnc < ActiveRecord::Migration
  def change
    add_column :dnc, :contact_id, :integer
  end
end
