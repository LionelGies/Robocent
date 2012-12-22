class CreateBillingEvents < ActiveRecord::Migration
  def change
    create_table :billing_events do |t|
      t.integer :user_id
      t.string :event_type
      t.text :response

      t.timestamps
    end
  end
end
