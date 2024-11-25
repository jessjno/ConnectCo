# == Schema Information
#
# Table name: responsibilities
#
#  id              :bigint           not null, primary key
#  description     :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  employee_id     :integer
#  organization_id :integer
#
class Responsibility < ApplicationRecord
  
  belongs_to :employee, required: true, class_name: "Employee", foreign_key: "employee_id", counter_cache: true
  validates :description, presence: true

end
