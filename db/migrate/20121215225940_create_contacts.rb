class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :list_id
      t.string :phone_number
      t.string :unique_identifier
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :do_not_import
      t.string :company_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :custom_1
      t.string :custom_2
      t.string :custom_3
      t.string :custom_4
      t.string :custom_5
      t.string :source

      t.timestamps
    end
  end
end
