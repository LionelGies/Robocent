require 'uri'
require 'net/http'

class Jobs::PlanMigration < Struct.new(:plan_migration)

  def perform
    user = plan_migration.user
    user.subscription.plan_id = plan_migration.new_plan_id
    user.subscription.status = "pending"
    user.subscription.save!
    plan_migration.destroy
  end
end