class AddShortcodeKeywordToLists < ActiveRecord::Migration
  def change
    add_column :lists, :shortcode_keyword, :string
  end
end
