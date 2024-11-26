class AddAdminToEmployee < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :admin, :boolean, default: false
  end
end
