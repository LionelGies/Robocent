class CreateDnc < ActiveRecord::Migration
  def change
    create_table :dnc do |t|
      t.string :phone
      t.integer :account
      t.boolean :global

      t.timestamps
    end
  end
end
