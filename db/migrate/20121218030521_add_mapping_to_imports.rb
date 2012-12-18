class AddMappingToImports < ActiveRecord::Migration
  def change
    add_column :imports, :mapping, :text
  end
end
