class Contact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :company_name, :custom_1,
    :custom_2, :custom_3, :custom_4, :custom_5, :do_not_import, :email,
    :first_name, :last_name, :list_id, :phone_number, :source, :state,
    :unique_identifier, :user_id, :zip

  belongs_to :user
  belongs_to :list
  has_many   :sms_messages
  has_one    :dnc,          :dependent => :destroy

  validates :user_id, :presence => true
  validates :list_id, :presence => true
  validate :phone_number_format
  validate :uniqueness_per_list

  scope :by_phone_number, lambda{ |phone| {:conditions => ["contacts.phone_number LIKE ?", "%#{phone}%"]} }

  after_create :update_number_of_contacts
  after_destroy :decrease_number_of_contacts

  def phone_number_format
    ph = formatted_number(self.phone_number)
    if ph.present?
      self.phone_number = ph
    else
      errors.add(:phone_number, "is Invalid")
    end
  end

  def uniqueness_per_list
    if self.new_record? and Contact.find_by_phone_number_and_list_id(self.phone_number, self.list_id).present?
      errors.add(:phone_number, "is already in this list")
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def address
    "#{address_1} #{address_2} #{city}"
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ['Id', 'List', 'Phone Number', 'Name', 'Email', 'Address', 'State', 'Zip', 'Source']
      all.each do |c|
        csv << [c.id, c.list.name, c.phone_number, c.name, c.email, c.address, c.state, c.zip, c.source]
      end
    end
  end

  def self.get_column_array
    column = Contact.column_names
    column.delete_at(column.index('id') || column.length)
    column.delete_at(column.index('user_id') || column.length)
    column.delete_at(column.index('list_id') || column.length)
    column.delete_at(column.index('source') || column.length)
    column.delete_at(column.index('created_at') || column.length)
    column.delete_at(column.index('updated_at') || column.length)
    return column
  end

  def set_value(col, value)
    self.phone_number = value if(col == "phone_number")
    self.unique_identifier = value if(col == "unique_identifier")
    self.first_name = value if(col == "first_name")
    self.last_name = value if(col == "last_name")
    self.email = value if(col == "email")
    self.company_name = value if(col == "company_name")
    self.address_1 = value if(col == "address_1")
    self.address_2 = value if(col == "address_2")
    self.city = value if(col == "city")
    self.state = value if(col == "state")
    self.zip = value if(col == "zip")
    self.custom_1 = value if(col == "custom_1")
    self.custom_2 = value if(col == "custom_2")
    self.custom_3 = value if(col == "custom_3")
    self.custom_4 = value if(col == "custom_4")
    self.custom_5 = value if(col == "custom_5")
  end

  def formatted_number(number)
    number = number.to_s
    digits = number.gsub(/\D/, '').split(//)

    if (digits.length == 11 and digits[0] == '1')
      # Strip leading 1
      digits.shift
    end

    if (digits.length == 10)
      digits = '(%s) %s-%s' % [ digits[0,3].join, digits[3,3].join, digits[6,4].join ]
    else
      return false
    end
    return digits.to_s
  end

  class << self
    def destroy_unlinked_contacts
      Contact.all.each do |contact|
        contact.destroy if contact.list.blank?
      end
    end

    handle_asynchronously :destroy_unlinked_contacts
  end

  private

  def update_number_of_contacts
    list.number_of_contacts += 1
    list.save
  end

  def decrease_number_of_contacts
    if list.present?
      list.number_of_contacts -= 1
      list.save
    end
  end
end
