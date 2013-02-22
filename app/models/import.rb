class Import < ActiveRecord::Base
  mount_uploader :file_name, ExcelUploader

  attr_accessible :file_name, :hold, :list_id, :number_of_contacts, :uploaded, :user_id

  belongs_to :user
  belongs_to :list

  validates :user_id, :presence => true
  validates :list_id, :presence => true

  def get_sheet
    au = ExcelUploader.new
    au.download!(self.file_name.url.to_s)
    au.retrieve_from_cache!(au.cache_name)
    self.file_name.cache_stored_file!

    file_path = self.file_name.file.path

    if file_path.include? "xlsx"
      book = RubyXL::Parser.parse(file_path)
      sheet1 = book.worksheets[0].extract_data
    elsif file_path.include? "xls"
      book = Spreadsheet.open file_path
      sheet1 = book.worksheet 0
    elsif file_path.include? "csv"
      require "csv"
      sheet1 = CSV.open(file_path, "rb")
    end

    return sheet1
  end
end
