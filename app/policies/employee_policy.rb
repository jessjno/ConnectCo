class EmployeePolicy
  attr_reader :current_employee, :employee

  def initialize(current_employee, employee)
    @current_employee = current_employee
    @employee = employee
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    current_employee.admin?
  end

  def create?
    current_employee.admin?
  end

  def destroy?
    current_employee.admin?
  end

  def can_manage_responsibilities?
    current_employee.admin? || current_employee == employee
  end

  def upload_csv?
    current_employee.admin? 
  end

  def edit_organization?
    current_employee.admin?
  end

  def update_organization?
    current_employee.admin?
  end
end
