class EmployeePolicy
  attr_reader :current_employee, :employee

  def initialize(current_employee, employee)
    @current_employee = current_employee
    @employee = employee
  end

  def show?
    true
  end


  def edit_responsibility?
    employee.admin? || employee == record
  end

  def update_responsibility?
    employee.admin? || employee == record
  end

end
