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
  belongs_to :parent_organization, class_name: "Organization", optional: true
  has_many :sub_organizations, class_name: "Organization", foreign_key: "parent_id"
  has_many :employees, class_name: "Employee", foreign_key: "organization_id", dependent: :nullify
  has_many :responsibilities, through: :employees
  
  def all_employees
    Employee.where(organization_id: all_organization_ids)
  end

  def all_organization_ids
    [id] + sub_organizations.flat_map(&:all_organization_ids)
  end

  def all_sub_organizations
    sub_organizations + sub_organizations.flat_map(&:all_sub_organizations)
  end
end
