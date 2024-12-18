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
require "rails_helper"

RSpec.describe Employee, type: :model do
  it "is valid with a valid first name, last name, email, and password" do
    employee = Employee.new(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123",
      organization_id: 1,
    )
  end

  it "is invalid without a first name" do
    employee = Employee.new(
      first_name: nil,
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123",
      organization_id: 1,
    )
  end

  it "is invalid without a last name" do
    employee = Employee.new(
      first_name: "John",
      last_name: nil,
      email: "john.doe@example.com",
      password: "password123",
      organization_id: 1,
    )
    expect(employee).not_to be_valid
  end

  it "is invalid without an email" do
    employee = Employee.new(
      first_name: "John",
      last_name: "Doe",
      email: nil,
      password: "password123",
      organization_id: 1,
    )
    expect(employee).not_to be_valid
  end

  it "is invalid without a password" do
    employee = Employee.new(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: nil,
      organization_id: 1,
    )
    expect(employee).not_to be_valid
  end
end
