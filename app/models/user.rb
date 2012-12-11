class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :organization_name, :organization_type, :name, :phone, :email,
    :time_zone, :password, :password_confirmation, :activation_state, :activation_token,
    :terms_and_conditions, :address, :state
  attr_accessor :terms_and_conditions

  validates :name, :presence => true
  validates :email, :format =>  { :with => /^[\w\.\+-]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,6}$/ }
  validates :organization_name, :presence => true
  validates :phone, :presence => true
  validates :organization_type, :presence => true
  validates :state, :presence => true
  validates_confirmation_of :password
  validates :password, :presence => true, :on => :create
  validates_uniqueness_of :email
  validates_acceptance_of :terms_and_conditions, :on => :create

  # scopes
  scope :active, :conditions => {:activation_state => 'active'}

  before_save :update_time_zone

  def update_time_zone
    self.time_zone = UsState::get_time_zone(self.state) if self.time_zone.blank?
  end
end
