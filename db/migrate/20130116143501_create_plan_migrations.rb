class CreatePlanMigrations < ActiveRecord::Migration
  def change
    create_table :plan_migrations do |t|
      t.integer :user_id
      t.integer :new_plan_id
      t.datetime :schedule_at

      t.timestamps
    end
  end
end
