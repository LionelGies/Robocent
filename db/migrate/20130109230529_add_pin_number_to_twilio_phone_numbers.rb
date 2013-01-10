class AddPinNumberToTwilioPhoneNumbers < ActiveRecord::Migration
  def change
    add_column :twilio_phone_numbers, :pin_number, :string
  end
end
