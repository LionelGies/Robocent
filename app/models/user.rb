class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :organization_name, :organization_type, :name, :phone, :email,
    :time_zone, :password, :password_confirmation, :activation_state, :activation_token,
    :terms_and_conditions, :promo_code, :text_messages_approval, :pop_up_count, :pin_number,
    :current_password
  
  attr_accessor :terms_and_conditions, :promo_code, :current_password

  has_one :subscription,          :dependent => :destroy
  has_one :billing_setting,       :dependent => :destroy
  has_one :plan_migration,        :dependent => :destroy
  has_one :twilio_phone_number,   :dependent => :destroy
  has_one :account_balance,       :dependent => :destroy
  has_many :receipts,             :dependent => :destroy
  has_many :lists,                :dependent => :destroy
  has_many :imports,              :dependent => :destroy
  has_many :contacts,             :dependent => :destroy
  has_many :billing_events,       :dependent => :destroy
  has_many :text_messages,        :dependent => :destroy
  has_many :sms_messages,         :dependent => :destroy
  has_many :calls,                :dependent => :destroy
  has_many :recordings,           :dependent => :destroy, :foreign_key => "userID"
  has_many :test_calls,           :dependent => :destroy, :foreign_key => "userID"
  has_many :dnc,                  :dependent => :destroy, :foreign_key => "account"

  
  validates :email, :format =>  { :with => /^[\w\.\+-]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/ }
  validates_uniqueness_of :email

  validates_length_of :password, :minimum => 6, :message => "must be at least 6 characters long", :if => :password
  validate :password_match, :if => [:password, :current_password], :on => :update


  #  validates :password, :presence => true, :on => :create
  #  validates_confirmation_of :password

  # scopes
  scope :active, :conditions => {:activation_state => 'active'}

  before_save :update_time_zone

  before_create :issue_pin_number
  after_create :create_account_balance


  def available_from_numbers
    from_nunmbers = Array.new
    from_nunmbers << self.twilio_phone_number.phone_number if self.twilio_phone_number.present?
    from_nunmbers << ShortCode.first.number if ShortCode.first.present?
    from_nunmbers
  end

  def current_balance
    account_balance.current_balance
  end

  def first_login?
    self.last_login_at.blank? and self.last_logout_at.blank?
  end

  def pop_up_counter
    self.pop_up_count += 1
    self.save
  end

  def allowed_to_create_keyword?
    max_keywords = self.subscription.plan.max_keywords
    total_keywords = self.lists.count(:all, :conditions => ["shortcode_keyword is not NULL"])
    total_keywords >= max_keywords ? false : true
  end

  def issue_pin_number
    begin
      r = Random.new
      pin = r.rand(11...99).to_s + r.rand(11...99).to_s + r.rand(11...99).to_s
      user = User.find_by_pin_number(pin)
    end while user.present?
    self.pin_number = pin
  end

  private
  def password_match
    unless User.authenticate(self.email, self.current_password)
      errors.add(:base, "Current password is wrong!")
    end
  end

  def update_time_zone
    #self.time_zone = UsState::get_time_zone(self.state) if self.time_zone.blank? or self.state != self.state_was
    self.time_zone = "Eastern Time (US & Canada)" if self.time_zone.blank?
  end

  def create_account_balance
    AccountBalance.create!(:user_id => self.id)
  end
end
