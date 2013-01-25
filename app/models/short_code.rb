class ShortCode < ActiveRecord::Base
  attr_accessible :number

  validates :number, :presence => true
end
