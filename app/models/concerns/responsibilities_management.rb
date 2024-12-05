module ResponsibilitiesManagement
  extend ActiveSupport::Concern

  def create_responsibility(employee, params)
    return unless employee 
    responsibility = employee.responsibilities.build(params)
    if responsibility.save
      responsibility 
    else
      false #
    end
  end

  def edit
    @employee = @responsibility.employee
    render "responsibilities/edit"
  end

  def update_responsibility(responsibility, params)
    responsibility.update(params)
  end

  def destroy_responsibility(responsibility)
    responsibility.destroy
  end

  private

  def set_responsibility
    @responsibility = Responsibility.find(params[:id])
  end

  def authorize_responsibility
    authorize @responsibility
  end

  def ensure_employee_is_authorized
    unless @responsibility && ResponsibilityPolicy.new(current_employee, @responsibility).show?
      raise Pundit::NotAuthorizedError, "Not allowed"
    end
  end
end
