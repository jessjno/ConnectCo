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
