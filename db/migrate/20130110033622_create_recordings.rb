class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.integer :user_id
      t.string :title
      t.integer :duration
      t.string :sid
      t.text :url

      t.timestamps
    end
  end
end
