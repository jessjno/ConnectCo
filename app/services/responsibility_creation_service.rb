class ResponsibilityCreationService
  def initialize(employee, responsibility_params)
    @employee = employee
    @responsibility_params = responsibility_params
  end

  def call
    responsibility = @employee.responsibilities.build(@responsibility_params)
    if responsibility.save
      responsibility
    else
      nil
    end
  end
end
