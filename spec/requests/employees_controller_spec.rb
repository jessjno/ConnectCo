require 'rails_helper'

RSpec.describe EmployeesController, type: :request do
  describe 'GET #index' do
    it 'returns a successful response' do
      organization = Organization.create!(name: 'Test Organization')

      employee = Employee.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        organization: organization  
      )
      
      sign_in employee  

      get employees_path

      expect(response).to have_http_status(:ok)
    end

    it 'assigns @employees' do
      organization = Organization.create!(name: 'Test Organization')

      employee = Employee.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123',
        organization: organization  
      )
      
      sign_in employee  

      get employees_path

      expect(assigns(:employees)).to include(employee)
    end
  end
end
