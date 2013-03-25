class List < ActiveRecord::Base
  attr_accessible :keyword, :name, :number_of_contacts, :type_of_list, :user_id,
    :shortcode_keyword, :greeting

  belongs_to  :user
  has_many    :imports,  :dependent => :destroy
  has_many    :contacts, :dependent => :destroy

  validate :name_uniqueness
  validate :keyword_uniqueness
  validate :shortcode_keyword_max, :on => :create

  validates :name, :presence => true
  validates :type_of_list, :presence => true
  validates :shortcode_keyword, :uniqueness => true, :if => Proc.new{|list| list.shortcode_keyword.present? }

  before_save{|l| l.shortcode_keyword = nil if l.shortcode_keyword.blank? }

  def name_uniqueness
    if self.new_record? and List.find_by_user_id_and_name_and_type_of_list(user.id, name, type_of_list).present?
      errors.add(:name, "has already been taken")
    elsif List.find(:first, :conditions => ["lists.id <> ? and lists.user_id = ? and lists.name = ? and lists.type_of_list = ?", self.id, user.id, self.name, self.type_of_list]).present?
      errors.add(:name, "has already been taken")
    end
  end

  def keyword_uniqueness
    if self.keyword.present?
      if self.new_record? and List.find_by_user_id_and_keyword(user.id, keyword).present?
        errors.add(:keyword, "has already been taken")
      elsif List.find(:first, :conditions => ["lists.id <> ? and lists.user_id = ? and lists.keyword = ?", id, user.id, self.keyword]).present?
        errors.add(:keyword, "has already been taken")
      end
    end
  end

  def shortcode_keyword_max
    max_keywords = self.user.subscription.plan.max_keywords
    total_keywords = self.user.lists.count(:all, :conditions => ["shortcode_keyword is not NULL"])
    if total_keywords >= max_keywords
      self.shortcode_keyword = nil
    end
  end

  scope :sum_number_of_contacts, :select => "SUM(number_of_contacts) as total"
  scope :by_call, :conditions => "type_of_list = 'call'"
  scope :by_text, :conditions => "type_of_list = 'text'"

end
