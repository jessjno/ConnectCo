require 'rails_helper'

RSpec.describe "organizations/index", type: :view do
  include Devise::Test::ControllerHelpers  # Include Devise test helpers

  before(:each) do
    @organization1 = Organization.create!(name: "Tech Corp")
    @organization2 = Organization.create!(name: "Innovators Inc.")

    @admin_employee = Employee.create!(first_name: "Admin", last_name: "User", email: "admin@example.com", password: "password123", admin: true, organization: @organization1)
    
    sign_in @admin_employee
    
    assign(:organizations, [@organization1, @organization2])

    render
  end

  it "displays a list of organizations" do
    [@organization1, @organization2].each do |organization|
      expect(rendered).to match(organization.name)
    end
  end

  it "renders a link to create a new organization" do
    expect(rendered).to have_link('New Organization', href: new_organization_path)
  end
end
