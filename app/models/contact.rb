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

  private

  def update_number_of_contacts
    list.number_of_contacts += 1
    list.save
  end
end
