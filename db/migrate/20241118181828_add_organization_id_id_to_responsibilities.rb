class AddOrganizationIdIdToResponsibilities < ActiveRecord::Migration[7.1]
  def change
    add_column :responsibilities, :organization_id, :integer
  end
end
