class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :organization_name, :organization_type, :name, :phone, :email,
    :time_zone, :password, :password_confirmation, :activation_state, :activation_token,
    :terms_and_conditions
  attr_accessor :terms_and_conditions

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_acceptance_of :terms_and_conditions

  # scopes
  scope :active, :conditions => {:activation_state => 'active'}

  ORGANIZATION_NAMES = [
    ['School', 'school'],
    ['Non-Profit', 'non_profit'],
    ['Political Campaign', 'political_campaign'],
    ['Small Business', 'small_business'],
    ['Government', 'government'],
    ['Other', 'other']
  ]

  TIME_ZONES = [
    ['Dhaka', 'dhaka']
  ]
end
