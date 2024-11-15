# == Schema Information
#
# Table name: organizations
#
#  id              :bigint           not null, primary key
#  description     :string
#  employees_count :integer
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_id       :integer
#
class Organization < ApplicationRecord
  has_many  :employees, class_name: "Employee", foreign_key: "organization_id", dependent: :nullify
end
