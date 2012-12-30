class List < ActiveRecord::Base
  attr_accessible :keyword, :name, :number_of_contacts, :type_of_list, :user_id

  belongs_to  :user
  has_many    :imports,  :dependent => :destroy
  has_many    :contacts, :dependent => :destroy
  has_many    :text_messages

  scope :sum_number_of_contacts, :select => "SUM(number_of_contacts) as total"
  scope :by_call, :conditions => "type_of_list = 'call'"
  scope :by_text, :conditions => "type_of_list = 'text'"

end
