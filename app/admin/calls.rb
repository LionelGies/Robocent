ActiveAdmin.register Call do
  config.filters = false
  menu :parent => 'Statistics', :label => "Call Stats"
  index do
    column "Call Id", :id
    column "Caller Name", :user
    column :schedule_at do |c| 
      c.schedule_at.in_time_zone("EST") 
    end
    column :started_at do |c| 
      c.started_at.in_time_zone("EST") if c.started_at.present? 
    end
    column "Starting Delay" do |c|
      Time.at((c.schedule_at.to_i - c.started_at.to_i)).utc.strftime("%H:%M:%S")
    end
    column :finished_at
    column :number_of_recipients
    column "Job Runningtime" do |c|
      if c.started_at.blank?
        "Not Started Yet!"
      else
        Time.at(c.started_at - c.finished_at).utc.strftime("%H:%M:%S")         
      end
    end
    column do |c|
      link_to "Call Queue Stats", call_queue_stats_admin_call_path(c)
    end
  end
  
  member_action :call_queue_stats do
    @call = Call.find(params[:id])
    @call_queues = @call.call_queues.order('id desc').page(params[:page]).per(100)
  end
end
