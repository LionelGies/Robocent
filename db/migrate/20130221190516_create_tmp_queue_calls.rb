class CreateTmpQueueCalls < ActiveRecord::Migration
  def change
    create_table :tmp_queue_calls do |t|
      t.integer :call_id
      t.string :phone_number

      t.timestamps
    end
  end
end
