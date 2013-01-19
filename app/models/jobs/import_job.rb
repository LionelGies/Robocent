require 'uri'
require 'net/http'

class Jobs::ImportJob < Struct.new(:import)

  def perform
    require "yaml"
    map = HashWithIndifferentAccess.new(YAML.load import.mapping)
    sheet = import.get_sheet
    count = 0
    sheet.each_with_index do |row, index|
      contact = import.user.contacts.new
      contact.list_id = import.list_id
      for i in 0..map.size.to_i - 1 do
        contact.set_value(map["#{i}"], row[i])
      end
      count += 1 if contact.save
    end
    import.hold = false
    import.uploaded = true
    import.save
  end

  #  def before(job)
  #    call.started_at = Time.zone.now
  #    call.save
  #  end
  #
  #  def after(job)
  #    call.finished_at = Time.zone.now
  #    call.save
  #  end
  #
  #  def failure(job)
  #    call.finished_at = Time.zone.now
  #    call.save
  #  end
end