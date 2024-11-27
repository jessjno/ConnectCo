class DropMembersTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :members, if_exists: true
  end

  def down
    create_table :members do |t|
      t.string :role
      t.timestamps
    end
  end
end
