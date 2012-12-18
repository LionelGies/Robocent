class Contact < ActiveRecord::Base
  attr_accessible :address_1, :address_2, :city, :company_name, :custom_1,
    :custom_2, :custom_3, :custom_4, :custom_5, :do_not_import, :email,
    :first_name, :last_name, :list_id, :phone_number, :source, :state,
    :unique_identifier, :user_id, :zip

  belongs_to :user
  belongs_to :list

  validates :user_id, :presence => true
  validates :list_id, :presence => true
  validates :phone_number, :presence => true

  scope :by_phone_number, lambda{ |phone| {:conditions => ["contacts.phone_number LIKE ?", "%#{phone}%"]} }

  after_create :update_number_of_contacts

  def name
    "#{first_name} #{last_name}"
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

  private

  def update_number_of_contacts
    list.number_of_contacts += 1
    list.save
  end
end
