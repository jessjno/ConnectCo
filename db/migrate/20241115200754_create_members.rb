class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :role
      t.integer :employee_id

      t.timestamps
    end
  end
end
