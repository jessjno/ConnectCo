class SetDefaultEmployeesCountInOrganizations < ActiveRecord::Migration[7.1]
  def change
    change_column_default :organizations, :employees_count, from: nil, to: 0
  end
end
