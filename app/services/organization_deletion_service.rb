class OrganizationDeletionService
  def initialize(organization)
    @organization = organization
  end

  def call
    if @organization.destroy
      true
    else
      false
    end
  end
end
