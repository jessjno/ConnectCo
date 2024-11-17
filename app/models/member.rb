# == Schema Information
#
# Table name: members
#
#  id          :bigint           not null, primary key
#  role        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employee_id :integer
#
class Member < ApplicationRecord

  belongs_to :employee, class_name: "Employee", foreign_key: "employee_id", counter_cache: :memberships_count
  belongs_to :organization

  enum role: { admin: 'admin', manager: 'manager', employee: 'employee', viewer: 'viewer', guest: 'guest' }

end
