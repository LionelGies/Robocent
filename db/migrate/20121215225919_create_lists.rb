class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :user_id
      t.string :name
      t.string :type_of_list
      t.integer :number_of_contacts, :default => 0
      t.string :keyword

      t.timestamps
    end
  end
end
