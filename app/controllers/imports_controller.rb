class ImportsController < ApplicationController
  before_filter :require_login

  layout "dashboard"
  
  def create
    @import = current_user.imports.new(params[:import])

    if @import.save
      redirect_to map_column_import_path(@import)
    else
      redirect_to new_contact_path, :alert => "Something went Wrong!!"
    end
  end

  def map_column
    @import = Import.find(params[:id])
    if @import.uploaded
      redirect_to new_contact_path, :alert => "This File is already uploaded."
    end
    @data = []
    sheet = @import.get_sheet

    @import.number_of_contacts = sheet.count - 1
    @import.hold = true if @import.number_of_contacts > 499
    @import.save

    if @import.hold
      redirect_to new_contact_path, :alert => "You are trying to upload more than 499 contacts in one File. Your upload is awaiting for moderation by admin."
    else
      sheet.first.each do |col|
        @data << col
      end
    end
  end

  def insert_into_db
    @import = Import.find(params[:id])
    sheet = @import.get_sheet
    count = 0
    sheet.each_with_index do |row, index|
      if index > 0
        contact = current_user.contacts.new
        contact.list_id = @import.list_id
        for i in 0..params["row"].size.to_i - 1 do
          contact.set_value(params["row"]["#{i}"], row[i])
        end
        count += 1 if contact.save
      end
    end
    
    @import.uploaded = true
    @import.save
    redirect_to new_contact_path, :notice => "successfully uploaded #{count} contacts."
  end
end