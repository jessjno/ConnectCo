class ResponsibilityPolicy
  attr_reader :employee, :responsibility

  def initialize(employee, responsibility)
    @employee = employee
    @responsibility = responsibility
  end

  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    employee.admin? || responsibility.employee == employee
  end

  def create?
    employee.admin? || responsibility.employee == employee
  end

  def destroy?
    employee.admin? || responsibility.employee == employee
  end
end
