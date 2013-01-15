class Dnc < ActiveRecord::Base
  set_table_name "dnc"
  attr_accessible :account, :global, :phone

  validates :phone, :presence => true
end
