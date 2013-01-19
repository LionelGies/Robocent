class AddSidToTwilioPhoneNumbers < ActiveRecord::Migration
  def change
    add_column :twilio_phone_numbers, :sid, :string
  end
end
