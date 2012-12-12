class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :stripe_id
      t.integer :amount
      t.string :currency
      t.string :interval
      t.string :name
      t.integer :trial_period_days
      t.integer :minimum_numbers
      t.integer :maximum_numbers
      t.float :price_per_call_or_text

      t.timestamps
    end
  end
end
