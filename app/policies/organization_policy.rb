class OrganizationPolicy 
  attr_reader :employee, :organization

  def initialize(employee, organization)
    @employee = employee
    @organization = organization
  end
  
  def index?
    true 
  end
  
  def show?
    true 
  end

  def edit?
    update?
  end

  def update?
    employee.member_id == 1
  end
end
