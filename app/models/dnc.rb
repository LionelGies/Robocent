class Dnc < ActiveRecord::Base
  set_table_name "dnc"
  attr_accessible :account, :global, :phone

  belongs_to :user, :foreign_key => :account

  validates :phone, :presence => true
end
