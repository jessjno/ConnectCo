require "rails_helper"

RSpec.describe Organization, type: :model do
  it "is valid with a valid name" do
    organization = Organization.new(name: 'Tech Company')
    expect(organization).to be_valid
  end

  it "is invalid without a name" do
    organization = Organization.new(name: nil)
    expect(organization).not_to be_valid
  end

  it "is invalid with a duplicate name" do
    Organization.create!(name: 'Tech Company')
    organization = Organization.new(name: 'Tech Company')
    expect(organization).not_to be_valid
  end
end
