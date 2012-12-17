class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :user_id
      t.integer :list_id
      t.string :file_name
      t.integer :number_of_contacts
      t.boolean :hold
      t.boolean :uploaded

      t.timestamps
    end
  end
end
