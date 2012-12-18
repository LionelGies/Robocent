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
    sheet1 = @import.get_sheet
    @import.number_of_contacts = sheet1.count
    @import.hold = true if @import.number_of_contacts > 499
    @import.save

    if @import.uploaded
      redirect_to new_contact_path, :alert => "This File is already uploaded."
    end
    @data = []
    sheet1 = @import.get_sheet
    sheet1.each_with_index do |row, index|
      @columns_count = row.count
      break if index > 9
      d = []
      row.each do |col|
        d << col if col.present?
        d << " " if col.blank?
      end
      @data << d
    end   
  end

  def insert_into_db
    @import = Import.find(params[:id])
    if params["row"].present?
      @import.mapping = params["row"].to_hash
      @import.save
      @import = Import.find(params[:id])
    end

    if @import.hold
      redirect_to new_contact_path, :alert => "Your list is currently pending administrator approval."
    else
      require "yaml"
      map = HashWithIndifferentAccess.new(YAML.load @import.mapping)
      sheet = @import.get_sheet
      count = 0
      sheet.each_with_index do |row, index|
          contact = current_user.contacts.new
          contact.list_id = @import.list_id
          for i in 0..map.size.to_i - 1 do
            contact.set_value(map["#{i}"], row[i])
          end
          count += 1 if contact.save
      end
    
      @import.uploaded = true
      @import.save
      redirect_to new_contact_path, :notice => "successfully uploaded #{count} contacts."
    end
  end
end