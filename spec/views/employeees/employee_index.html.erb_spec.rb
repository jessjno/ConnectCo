require 'rails_helper'

RSpec.describe "employees/index", type: :view do
  include Devise::Test::ControllerHelpers
  before(:each) do
    @organization = Organization.create!(name: "Tech Corp")

    @admin_employee = Employee.create!(first_name: "Admin", last_name: "User", email: "admin@example.com", password: "password123", organization: @organization, admin: true)
    @employee1 = Employee.create!(first_name: "Employee 1", last_name: "Test 1", email: "employee1@example.com", password: "password123", organization: @organization)
    @employee2 = Employee.create!(first_name: "Employee 2", last_name: "Test 2", email: "employee2@example.com", password: "password123", organization: @organization)
    @employee3 = Employee.create!(first_name: "Employee 3", last_name: "Test 3", email: "employee3@example.com", password: "password123", organization: @organization)
    @employee4 = Employee.create!(first_name: "Employee 4", last_name: "Test 4", email: "employee4@example.com", password: "password123", organization: @organization)
    @employee5 = Employee.create!(first_name: "Employee 5", last_name: "Test 5", email: "employee5@example.com", password: "password123", organization: @organization)
    
    sign_in @admin_employee

    @q = Employee.ransack(params[:q])

    @employees = [@employee1, @employee2, @employee3, @employee4, @employee5]

    allow(Employee).to receive(:page).and_return(Employee.all.page(1).per(20))  # Adjust `per(10)` as per your pagination setting
    assign(:employees, Employee.page(1).per(20))
  end

  it "displays a list of employees" do
    render

    @employees.each do |employee|
      expect(rendered).to match(employee.first_name)
    end
  end

  it "renders a link to create a new employee" do
    render

    expect(rendered).to have_link('New Employee', href: new_employee_path)
  end
end
