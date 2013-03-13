ActiveAdmin.register TextMessage do
  actions :all, :except => [:edit, :new, :destroy]

  filter :user
  filter :schedule_at
  filter :started_at
  filter :finished_at

  index do
    column :id
    column :user
    column :sending_from
    column :number_of_recipients
    column :total_processed
    column :succeeded
    column :schedule_at
    column :started_at
    column :status
    column "manage" do |msg|
      if msg.queue_texts.present? and msg.status == "started"
        link_to "Pause", pause_admin_text_message_path(msg), :confirm => "Are you sure?"
      elsif msg.queue_texts.present? and msg.status == "paused"
        link_to "Resume", resume_admin_text_message_path(msg), :confirm => "Are you sure?"
      end
    end
    column "Cancel" do |msg|
      link_to "cancel", cancel_admin_text_message_path(msg), :confirm => "Are you sure?" if msg.queue_texts.present?
    end
    column "Approve" do |msg|
      link_to 'Approve', approve_admin_text_message_path(msg), :confirm => "Are you sure to approve?" if msg.status == "pending"
    end
  end

  controller do
    def scoped_collection
      TextMessage.where("status <> 'finished'")
    end
  end

  member_action :pause do
    @msg = TextMessage.find(params[:id])
    if @msg.present?
      job = @msg.scheduled_job
      job.destroy if job.present?
      @msg.status = "paused"
      @msg.save
      @msg.queue_texts.each do |qt|
        qt.paused = true
        qt.save
      end
    end
    redirect_to :action => :index
  end

  member_action :cancel do
    @msg = TextMessage.find(params[:id])
    if @msg.present?
      job = @msg.scheduled_job
      job.destroy if job.present?
      @msg.status = "canceled"
      @msg.save
      @msg.queue_texts.each do |qt|
        qt.destroy
      end
    end
    redirect_to :action => :index
  end

  member_action :resume do
    @msg = TextMessage.find(params[:id])
    if @msg.present?
      @msg.status = "resumed"
      @msg.save
      @msg.queue_texts.each do |qt|
        qt.paused = false
        qt.save
      end
      if @msg.scheduled_job.blank?
        delay_time = 2
        Delayed::Job.enqueue Jobs::TextMessageJob.new(@msg), :priority => 0 , :run_at => delay_time.seconds.from_now, :queue => "text", :text_message_id => @msg.id
      end
    end
    redirect_to :action => :index
  end
  
  member_action :approve do
    @text_message = TextMessage.find(params[:id])
    if @text_message.present?
      @text_message.add_send_text_job
      @text_message.status = "approved"
      @text_message.save
    end
    redirect_to :action => :index
  end
end
