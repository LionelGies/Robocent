class CreateSmsMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
      t.integer :user_id
      t.string :sms_sid
      t.text :body
      t.string :from
      t.string :from_state
      t.string :from_city
      t.string :from_country
      t.string :from_zip
      t.string :to
      t.string :status
      t.integer :contact_id

      t.timestamps
    end
  end
end
