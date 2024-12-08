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
    admin_only?
  end

  def create?
    admin_only?
  end

  def edit?
    update?
  end

  def update?
    admin_only?
  end

  def destroy?
    admin_only?
  end

  private

  # Helper method to check if the employee is an admin
  def admin_only?
    employee.admin?
  end
end
