class AddMonthlyFreeCreditInPlan < ActiveRecord::Migration
  def change
    add_column :plans, :monthly_free_credit, :float
  end
end
