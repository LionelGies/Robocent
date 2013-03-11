class Dnc < ActiveRecord::Base
  self.table_name = "dnc"
  attr_accessible :account, :global, :phone, :contact_id

  belongs_to :user, :foreign_key => :account
  belongs_to :contact

  validates :phone, :presence => true
  validates :contact_id, :uniqueness => true
end
