class AddSlugtoUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slug, :string, default: true
    add_index :users, :slug
  end
end
