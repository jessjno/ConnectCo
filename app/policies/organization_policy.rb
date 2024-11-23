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

  def new?
    employee.admin?
  end

  def create?
    employee.admin?
  end

  def edit?
    update?
  end

  def update?
    employee.admin?
  end

  def destroy?
    employee.admin?
  end
end
