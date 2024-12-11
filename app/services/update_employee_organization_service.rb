class UpdateEmployeeOrganizationService
  def initialize(employee, organization_id)
    @employee = employee
    @organization_id = organization_id
  end

  def call
    @employee.update(organization_id: @organization_id)
  end
end
