class RemoveEmployeeIdFromMember < ActiveRecord::Migration[7.1]
  def change
    remove_column :members, :employee_id, :integer
  end
end
