class AddGreetingToLists < ActiveRecord::Migration
  def change
    add_column :lists, :greeting, :string
  end
end
