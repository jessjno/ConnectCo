# == Schema Information
#
# Table name: employees
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  image_url              :string
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
  
  belongs_to :organization
  belongs_to :manager, class_name: "Employee", optional: true
  belongs_to :member, optional: true 
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
  has_many :responsibilities
  validates :first_name, :last_name, :organization_id, presence: true
  validates :organization_id, presence: true
 
  def admin?
    self.admin
  end

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "title"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["organization", "responsibilities"]
  end

  def profile_image
    image_url.presence || ActionController::Base.helpers.asset_path('default_profile.png')
  end

  def full_name
    "#{first_name} #{last_name} (#{title || 'No Title'})"
  end
 end
