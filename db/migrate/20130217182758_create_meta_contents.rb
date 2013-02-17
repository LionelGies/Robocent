class CreateMetaContents < ActiveRecord::Migration
  def change
    create_table :meta_contents do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
