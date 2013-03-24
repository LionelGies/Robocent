class AddPopUpCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pop_up_count, :integer, :default => 0
  end
end
