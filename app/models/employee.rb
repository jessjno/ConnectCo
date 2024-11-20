# == Schema Information
#
# Table name: employees
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  memberships_count      :integer
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  responsibilities_count :integer
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  manager_id             :integer
#  member_id              :integer
#  organization_id        :integer
#
# Indexes
#
#  index_employees_on_email                 (email) UNIQUE
#  index_employees_on_manager_id            (manager_id)
#  index_employees_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (manager_id => employees.id)
#
class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  belongs_to :member, optional: true # Assuming an employee may or may not have a role
  belongs_to :organization
  belongs_to :manager, class_name: "Employee", optional: true
  
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"

  validates :first_name, :last_name, :organization_id, presence: true

end
