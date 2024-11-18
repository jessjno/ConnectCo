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
  #has_many :memberships through: :employees
  
  # def hierarchy
  #   [self] + sub_organizations.flat_map(&:hierarchy)
  # end

  def self.build_tree(organizations, parent_id = nil)
    result = organizations
      .select { |org| org.parent_id == parent_id }
      .map do |org|
        { organization: org, children: build_tree(organizations, org.id) }
      end
      Rails.logger.info "Tree for parent_id #{parent_id}: #{result.inspect}"
      result
  end
end
