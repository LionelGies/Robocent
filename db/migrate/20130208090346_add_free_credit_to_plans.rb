class AddFreeCreditToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :free_credit, :float
  end
end
