class AddImageUrlToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :image_url, :string
  end
end
