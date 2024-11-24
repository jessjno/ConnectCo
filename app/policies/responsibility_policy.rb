class ResponsibilityPolicy
  attr_reader :employee, :responsibility

  def initialize(employee, responsibility)
    @employee = employee
    @responsibility = responsibility
  end

  def show?
    true
    
  end

  def edit_responsibility?
    update_responsibility? # employee.member_id == 1 || employee.id == record.employee_id
  end

  def update_responsibility?
    # Example: Allow employees to update their own responsibilities
    responsibility.employee_id == employee.id
  end

  def edit?
    update? # employee == responsibility.employee
  end

  def update?
    employee == responsibility.employee
  end

end
