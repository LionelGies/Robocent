class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :user_id
      t.integer :recording_id
      t.string :caller_id_number
      t.string :list_ids
      t.string :test_send_to
      t.integer :number_of_recipients
      t.float :cost_per_call
      t.float :total_cost
      t.datetime :schedule_at

      t.timestamps
    end
  end
end
