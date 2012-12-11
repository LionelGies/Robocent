class AddAddressAndStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :state, :string
  end
end
