class CreateShortCodes < ActiveRecord::Migration
  def change
    create_table :short_codes do |t|
      t.string :number

      t.timestamps
    end
  end
end
