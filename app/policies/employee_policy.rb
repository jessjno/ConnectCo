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
    admin_only?
  end

  def create?
    admin_only?
  end

  def destroy?
    admin_only?
  end

  def can_manage_responsibilities?
    admin_only? || current_employee == employee
  end

  def upload_csv?
    admin_only?
  end

  def edit_organization?
    admin_only?
  end

  def update_organization?
    admin_only?
  end

  def edit_manager?
    admin_only?
  end

  def update_manager?
    admin_only?
  end

  private

  # Helper method to check if the current employee is an admin
  def admin_only?
    current_employee.admin?
  end
end
