class CreateTwilioPhoneNumbers < ActiveRecord::Migration
  def change
    create_table :twilio_phone_numbers do |t|
      t.integer :user_id
      t.string :area_code
      t.string :phone_number

      t.timestamps
    end
  end
end
