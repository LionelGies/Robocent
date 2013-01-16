class PlanMigration < ActiveRecord::Base
  attr_accessible :new_plan_id, :schedule_at, :user_id

  belongs_to :user
  belongs_to :plan, :foreign_key => "new_plan_id"

  after_create :enqueue_migration

  def enqueue_migration
    delay_time = ((Time.parse(self.schedule_at.to_s) - Time.parse((DateTime.now).to_s))).to_i
    delay_time = 5 if delay_time < 5
    Delayed::Job.enqueue Jobs::PlanMigration.new(self), 0 , delay_time.seconds.from_now, :queue => "plan_migration"
  end
end
