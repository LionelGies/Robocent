class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :organization_name, :organization_type, :name, :phone, :email,
    :time_zone, :password, :password_confirmation, :activation_state, :activation_token,
    :terms_and_conditions, :promo_code
  attr_accessor :terms_and_conditions, :promo_code

  has_one :billing_setting,       :dependent => :destroy
  has_one :subscription,          :dependent => :destroy
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
  

  validates :name, :presence => true
  validates :email, :format =>  { :with => /^[\w\.\+-]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/ }
  #validates :organization_name, :presence => true
  #validates :phone, :presence => true
  #validates :organization_type, :presence => true
  validates :time_zone, :presence => true, :on => :update
  #validates :state, :presence => true
  validates_confirmation_of :password
  validates :password, :presence => true, :on => :create
  validates_uniqueness_of :email
  validates_acceptance_of :terms_and_conditions, :on => :create

  # scopes
  scope :active, :conditions => {:activation_state => 'active'}

  #before_save :update_time_zone

  after_create :create_account_balance


  def current_balance
    account_balance.current_balance
  end

  private

  def update_time_zone
    self.time_zone = UsState::get_time_zone(self.state) if self.time_zone.blank? or self.state != self.state_was
  end

  def create_account_balance
    AccountBalance.create!(:user_id => self.id)
  end
end
