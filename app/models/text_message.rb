class TextMessage < ActiveRecord::Base
  attr_accessor :schedule_now
  attr_accessible :content, :list_ids, :sending_option, :test_send_to, :user_id,
    :number_of_recipients, :cost_per_text, :number_of_texts_required, :total_cost,
    :schedule_at, :schedule_now, :total_processed, :succeeded, :succeeded_numbers,
    :failed_alerts, :started_at, :finished_at, :status

  belongs_to :user
  has_many :queue_texts
  has_one :scheduled_job, :class_name => "DelayedJob"

  validates :content,         :presence => true
  validates :list_ids,        :presence => true
  validates :sending_option,  :presence => true
  validates :user_id,         :presence => true

  before_create :charge_difference
  after_create :create_receipt
  before_create {|t| t.status = "pending" }
  after_create :check_for_approval

  def lists
    List.find(:all, :conditions => ["id in (?)", list_ids.split(",")])
  end

  def percent_completed
    ((succeeded.to_f / number_of_recipients.to_f) * 100.0).to_i
  end

  def sending_from
    if self.sending_option == 1
      self.user.twilio_phone_number.phone_number
    else
      "Shortcode"
    end
  end

  def total_unique_contacts
    numbers = []
    self.lists.each do |list|
      numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
    end
    numbers.size
  end

  def failed
    self.total_processed - self.succeeded
  end

  def to_csv_succeeded_numbers
    require 'csv'
    CSV.generate do |csv|
      self.succeeded_numbers.split(",").each do |number|
        csv << [number]
      end
    end
  end

  def to_csv_errors
    require 'csv'
    CSV.generate do |csv|
      self.failed_alerts.split(",").each do |text|
        csv << [text]
      end
    end
  end
  
  def check_for_approval
	if(self.sending_option == 1 or self.number_of_recipients < 50)
		self.status = "approved"
		save
		send_text_to_queue
		#Notification.need_text_message_approval(self.id).deliver
	else
		Notification.need_text_message_approval(self.id).deliver
	end
  end
  
  def send_text_to_queue
    numbers = []
    lists.each do |list|
      numbers = (numbers + Contact.where(:list_id => list.id).uniq.pluck(:phone_number)).uniq
    end
	numbers = numbers - Dnc.where(:account => self.user_id).pluck(:phone).uniq
    numbers.each do |number|
      self.queue_texts.create(:phone_number => number)
    end

    delay_time = ((Time.parse(self.schedule_at.to_s) - Time.parse((DateTime.now).to_s))).to_i
    delay_time = 5 if delay_time < 5
    Delayed::Job.enqueue Jobs::TextMessageJob.new(self), :priority => 0 , :run_at => delay_time.seconds.from_now, :queue => "text", :text_message_id => self.id
  end

  private

  def charge_difference
    if user.account_balance.current_balance < total_cost
      charge_difference = ((total_cost - user.account_balance.current_balance) * 100).ceil.to_f / 100.0
      charge_difference = 5 if charge_difference < 5
      user.billing_setting.charge(charge_difference, "Automatically funded account")
    end
  end

  def create_receipt
    r = Receipt.new(:memo => "To send #{number_of_texts_required} text messages", :debit => total_cost)
    user.receipts << r
  end


end
