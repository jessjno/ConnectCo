# == Schema Information
#
# Table name: members
#
#  id         :bigint           not null, primary key
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Member < ApplicationRecord
  has_many :employees
  validates :role, presence: true
  
  enum role: { admin: 'admin', manager: 'manager', employee: 'employee', viewer: 'viewer', guest: 'guest' }

end
