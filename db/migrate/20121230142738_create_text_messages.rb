class CreateTextMessages < ActiveRecord::Migration
  def change
    create_table :text_messages do |t|
      t.text :content
      t.integer :sending_option
      t.string :test_send_to
      t.integer :list_id
      t.integer :user_id
      t.integer :number_of_recipients
      t.float :cost_per_text
      t.integer :number_of_texts_required
      t.float :total_cost
      
      t.timestamps
    end
  end
end
