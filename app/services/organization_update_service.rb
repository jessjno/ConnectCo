class OrganizationUpdateService
  def initialize(organization, organization_params)
    @organization = organization
    @organization_params = organization_params
  end

  def call
    if @organization.update(@organization_params)
      @organization
    else
      nil
    end
  end
end
