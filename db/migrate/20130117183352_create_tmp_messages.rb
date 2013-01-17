class CreateTmpMessages < ActiveRecord::Migration
  def change
    create_table :tmp_messages do |t|
      t.string :name
      t.string :email
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
