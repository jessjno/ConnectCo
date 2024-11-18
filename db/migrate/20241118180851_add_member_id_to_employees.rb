class AddMemberIdToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :member_id, :integer
  end
end
