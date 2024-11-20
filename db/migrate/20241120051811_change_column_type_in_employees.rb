class ChangeColumnTypeInEmployees < ActiveRecord::Migration[7.1]
  def change
    change_column :employees, :manager_id, :integer
  end
end
