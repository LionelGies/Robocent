class AddTextMessageIdToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :text_message_id, :integer
  end
end
