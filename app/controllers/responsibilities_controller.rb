class ResponsibilitiesController < ApplicationController
  include ResponsibilitiesManagement
  before_action :set_responsibility, only: [:edit, :update, :destroy]
  before_action :authorize_responsibility, only: [:edit, :update, :destroy]
  before_action :set_employee
  before_action :ensure_employee_is_authorized, only: [:edit, :update, :destroy]

  def index
    @list_of_responsibilities = Responsibility.order(created_at: :desc)
    @responsibility = Responsibility.new
    render({ :template => "responsibilities/index" })
  end

  def show
    @employee = Employee.find(params[:id])
    @responsibilities = @employee.responsibilities
    @responsibility = Responsibility.new 
    authorize @employee
  end

  def create
    service = ResponsibilityCreationService.new(@employee, responsibility_params)
    @responsibility = service.call

    if @responsibility
      redirect_to employee_path(@employee), notice: "Responsibility created successfully."
    else
      redirect_to employee_path(@employee), alert: "Failed to create responsibility."
    end
  end

  def edit
    @employee = @responsibility.employee
    render "responsibilities/edit"
  end

  def update
    service = ResponsibilityUpdateService.new(@responsibility, responsibility_params)
    @responsibility = service.call

    if @responsibility
      redirect_to employee_path(@responsibility.employee), notice: "Responsibility updated successfully."
    else
      redirect_to employee_path(@responsibility.employee), alert: "Failed to update responsibility."
    end
  end

  def destroy
    service = ResponsibilityDeletionService.new(@responsibility)
    if service.call
      redirect_to employee_path(@responsibility.employee), notice: "Responsibility deleted successfully."
    else
      redirect_to employee_path(@responsibility.employee), alert: "Failed to delete responsibility."
    end
  end

  private

  def responsibility_params
    params.require(:responsibility).permit(:description, :employee_id)
  end

  def set_responsibility
    @responsibility = Responsibility.find(params[:id])
  end

  def set_employee
    @employee = Employee.find_by(id: params[:employee_id])
  end

  def authorize_responsibility
    authorize @responsibility
  end

  # Can be moved to a policy
  def ensure_employee_is_authorized
    if @responsibility.nil? || !ResponsibilityPolicy.new(current_employee, @responsibility).show?
      raise Pundit::NotAuthorizedError, "Not allowed"
    end
  end
end
