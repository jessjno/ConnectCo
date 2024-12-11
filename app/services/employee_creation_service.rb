class EmployeeCreationService
  def initialize(employee_params)
    @employee_params = employee_params
  end

  def call
    employee = Employee.new(@employee_params)
    if employee.save
      employee
    else
      raise "Failed to create employee: #{employee.errors.full_messages.to_sentence}"
    end
  end
end
