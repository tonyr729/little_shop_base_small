class AddSlugtoItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :slug, :string, default: true
    add_index :items, :slug
  end
end
