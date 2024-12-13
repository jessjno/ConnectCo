require 'rails_helper'

RSpec.describe OrganizationsController, type: :request do
  let(:organization) { Organization.create!(name: "Test Organization", description: "A test organization") }
  let(:admin_employee) { Employee.create!(first_name: "Admin", last_name: "Employee", email: "admin@example.com", password: "password123", admin: true, organization: organization) }  

  before do
    sign_in admin_employee  # This simulates an admin employee being logged in
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get organizations_path
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @organizations' do
      get organizations_path
      expect(assigns(:organizations)).to include(organization)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get organization_path(organization)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @organization' do
      get organization_path(organization)
      expect(assigns(:organization)).to eq(organization)
    end

    it 'assigns @employees and @sub_organizations' do
      get organization_path(organization)
      expect(assigns(:employees)).to eq(organization.employees)
      expect(assigns(:sub_organizations)).to eq(organization.sub_organizations)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get new_organization_path
      expect(response).to have_http_status(:ok)
    end

    it 'assigns a new organization' do
      get new_organization_path
      expect(assigns(:organization)).to be_a_new(Organization)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new organization and redirects' do
        expect {
          post organizations_path, params: { organization: { name: "New Organization", description: "Description" } }
        }.to change(Organization, :count).by(1)
        expect(response).to redirect_to(organizations_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new organization and renders the new template' do
        expect {
          post organizations_path, params: { organization: { name: "", description: "Description" } }
        }.to_not change(Organization, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get edit_organization_path(organization)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @organization' do
      get edit_organization_path(organization)
      expect(assigns(:organization)).to eq(organization)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the organization and redirects' do
        patch organization_path(organization), params: { organization: { name: "Updated Organization" } }
        expect(organization.reload.name).to eq("Updated Organization")
        expect(response).to redirect_to(organization_path(organization))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the organization and renders the edit template' do
        patch organization_path(organization), params: { organization: { name: "" } }
        expect(organization.reload.name).to eq("Test Organization")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the organization and redirects' do
      organization_to_destroy = Organization.create!(name: "Organization to Destroy", description: "This one will be deleted")
      expect {
        delete organization_path(organization_to_destroy)
      }.to change(Organization, :count).by(-1)
      expect(response).to redirect_to(organizations_path)
    end
  end
end
