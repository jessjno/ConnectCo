class AddManagerIdToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_reference :employees, :manager, foreign_key: { to_table: :employees }, index: true, null: true
  end
end
