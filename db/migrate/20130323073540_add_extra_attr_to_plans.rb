class AddExtraAttrToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :monthly_free_credit, :float, :default => 0
    add_column :plans, :recurring, :boolean, :default => 0
    add_column :plans, :default, :boolean, :default => 0
    add_column :plans, :max_keywords, :integer
    add_column :plans, :card_required, :boolean, :default => 0
  end
end
