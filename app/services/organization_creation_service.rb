class OrganizationCreationService
  def initialize(organization_params)
    @organization_params = organization_params
  end

  def call
    organization = Organization.new(@organization_params)
    if organization.save
      organization
    else
      nil
    end
  end
end
