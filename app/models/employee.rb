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
  # Include default devise modules for authentication
  include ResponsibilitiesManagement
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations: An employee belongs to an organization and can have a manager and subordinates.
  belongs_to :organization
  belongs_to :manager, class_name: "Employee", optional: true
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
  has_many :responsibilities

  # Callbacks: Ensure dependencies are checked before destroying an employee
  before_destroy :check_dependencies

  # Validations: Ensure required fields are present
  validates :first_name, :last_name, presence: true

  scope :by_last_name, -> { order(:last_name) }
  scope :with_organization, -> { includes(:organization) }
  scope :paginate, ->(page = 1, per_page = 20) { page(page).per(per_page) }

  def admin?
    self.admin
  end

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "title"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["organization", "responsibilities"]
  end

  # Instance method to return the employee's profile image or a default image if not set
  def profile_image
    image_url.presence || ActionController::Base.helpers.asset_path("default_profile.png")
  end

  def full_name
    "#{first_name} #{last_name} (#{title || "No Title"})"
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  private

  # Callback to ensure employees with subordinates can't be deleted
  def check_dependencies
    if subordinates.any?
      errors.add(:base, "Cannot delete employee with subordinates. Reassign or remove subordinates first.")
      throw(:abort)
    end
  end
end
