class Import < ActiveRecord::Base
  attr_accessible :file_name, :hold, :list_id, :number_of_contacts, :uploaded, :user_id

  belongs_to :user
  belongs_to :list
end
