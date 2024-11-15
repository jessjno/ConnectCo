class CreateResponsibilities < ActiveRecord::Migration[7.1]
  def change
    create_table :responsibilities do |t|
      t.string :name
      t.string :description
      t.integer :employee_id

      t.timestamps
    end
  end
end
