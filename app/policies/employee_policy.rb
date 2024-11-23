class EmployeePolicy
  attr_reader :current_employee, :employee

  def initialize(current_employee, employee)
    @current_employee = current_employee
    @employee = employee
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


  def edit_responsibility?
    current_employee.admin?|| current_employee == record
  end

  def update_responsibility?
    current_employee.admin? || current_employee == record
  end

end
