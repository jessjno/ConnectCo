class RemoveMemberIdFromEmployees < ActiveRecord::Migration[7.1]
  def change
    remove_column :employees, :member_id, :integer
  end
end
