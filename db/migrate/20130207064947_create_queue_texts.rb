class CreateQueueTexts < ActiveRecord::Migration
  def change
    create_table :queue_texts do |t|
      t.integer :text_message_id
      t.string :phone_number
      t.boolean :paused, :default => false

      t.timestamps
    end
  end
end
