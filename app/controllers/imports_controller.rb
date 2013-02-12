class ImportsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource

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
    @import.hold = false
    @import.uploaded = false
    sheet1 = @import.get_sheet
    @import.number_of_contacts = sheet1.count
    @import.hold = true if @import.number_of_contacts > 499
    @import.save

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
    
    if @import.uploaded
      redirect_to new_contact_path, :alert => "This File is already uploaded."
    elsif @columns_count == 1
      redirect_to insert_into_db_import_path(@import, :"row[0]" => "phone_number")
    end
  end

  def insert_into_db
    @import = Import.find(params[:id])
    if params["row"].present?
      @import.mapping = params["row"].to_hash
      @import.save
      @import = Import.find(params[:id])
    end

    @total_contacts_count = current_user.lists.sum_number_of_contacts.first.total.to_i
    @allowed_contacts_count = current_user.subscription.plan.maximum_numbers

    if @import.hold
      redirect_to new_contact_path, :alert => "Your list is currently pending administrator approval."
    elsif((@total_contacts_count + @import.number_of_contacts) > @allowed_contacts_count)
      @import.hold = true
      @import.save
      redirect_to new_contact_path, :alert => "Your list is currently pending administrator approval. Please upgrade your account in order to add more subscribers to the system."
    else
      Delayed::Job.enqueue Jobs::ImportJob.new(@import), 0 , 2.seconds.from_now, :queue => "import"
      redirect_to new_contact_path, :notice => "Your uploads successfully placed into queue."
    end
  end
end