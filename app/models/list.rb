class List < ActiveRecord::Base
  attr_accessible :keyword, :name, :number_of_contacts, :type_of_list, :user_id,
    :shortcode_keyword

  belongs_to  :user
  has_many    :imports,  :dependent => :destroy
  has_many    :contacts, :dependent => :destroy

  validates :name, :presence => true
  validates :type_of_list, :presence => true
  validates :keyword, :presence => true
  validates :shortcode_keyword, :presence => true, :uniqueness => true

  validate :keyword_uniqueness

  def keyword_uniqueness
    if List.find_by_user_id_and_keyword(user.id, self.keyword).present?
      errors.add(:keyword, "You have already used this keyword!")
    end
  end

  scope :sum_number_of_contacts, :select => "SUM(number_of_contacts) as total"
  scope :by_call, :conditions => "type_of_list = 'call'"
  scope :by_text, :conditions => "type_of_list = 'text'"

end
