# == Schema Information
#
# Table name: organizations
#
#  id              :bigint           not null, primary key
#  description     :string
#  employees_count :integer          default(0)
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_id       :integer
#
class Organization < ApplicationRecord
  include ResponsibilitiesManagement

  belongs_to :parent_organization, class_name: "Organization", optional: true
  has_many :sub_organizations, class_name: "Organization", foreign_key: "parent_id"
  has_many :employees, class_name: "Employee", foreign_key: "organization_id", dependent: :nullify
  has_many :responsibilities, through: :employees

  # Callback to ensure organization dependencies are checked before deletion
  before_destroy :check_dependencies
  
  # Returns all employees in this organization and its sub-organizations
  def all_employees
    Employee.where(organization_id: all_organization_ids)
  end

  # Returns the IDs of this organization and all its sub-organizations
  def all_organization_ids
    [id] + sub_organizations.flat_map(&:all_organization_ids)
  end

  def all_sub_organizations
    sub_organizations + sub_organizations.flat_map(&:all_sub_organizations)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "employees_count", "id", "name", "parent_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["employees", "parent"]
  end

  # Callback to check dependencies before organization is destroyed
  def check_dependencies
    if employees.exists?
      errors.add(:base, "Cannot delete organization with employees assigned to it.")
      throw(:abort)
    elsif sub_organizations.exists?
      errors.add(:base, "Cannot delete organization with sub-organizations assigned to it.")
      throw(:abort) 
    end
  end
end
