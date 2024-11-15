class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :description
      t.integer :parent_id
      t.integer :employees_count

      t.timestamps
    end
  end
end
