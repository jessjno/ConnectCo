class EmployeesController < ApplicationController
  include CsvUploadable #Do you need this here?
  before_action :set_employee, only: [:show, :edit, :update, :destroy, :edit_responsibility, :update_responsibility, :edit_organization, :update_organization, :edit_manager, :update_manager]
  before_action :set_responsibility, only: [:edit_responsibility, :update_responsibility]

  before_action :authorize_employee, only: [:index, :show, :edit, :update, :destroy, :upload_csv, :edit_responsibility, :update_responsibility, :edit_organization, :update_organization, :edit_manager, :update_manager]
  before_action :authenticate_admin!, only: [:new, :create]

  after_action :verify_authorized, except: [:show]

  def sign_in
    if current_employee
      redirect_to root_path
    end
  end

  def new
    @employee = Employee.new
    authorize @employee
  end

  def upload_csv
    upload_csv_logic(params[:file], "employee")
  end

  def create
    authorize_employee
    service = EmployeeCreationService.new(employee_params)
    @employee = service.call

    if @employee
      redirect_to employees_path, notice: "Employee created successfully."
    else
      render :new, alert: "Failed to create employee."
    end
  end

  def index
    @q = Employee.ransack(params[:q])
    @employees = @q.result.with_organization.by_last_name.paginate(params[:page]).includes(:organization)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @q = Employee.ransack(params[:q])
    @employee = Employee.with_organization.find(params[:id])
    @breadcrumbs = [
      { content: "Employees", href: employees_path },
      { content: @employee.organization.name, href: organization_path(@employee.organization) },
      { content: @employee.to_s },
    ]
    @responsibilities = @employee.responsibilities
    @responsibility = Responsibility.new
  end

  def edit
    @current_employee = current_employee
  end

  def update
    @current_employee = current_employee
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Profile updated successfully."
    else
      render :edit
    end
  end

  def edit_responsibility
    authorize @responsibility, :edit?
  end

  def update_responsibility
    authorize @responsibility, :update?

    if @responsibility.update(responsibility_params)
      redirect_to employee_path(@employee), notice: "Responsibility updated successfully."
    else
      flash[:alert] = "Failed to update responsibility: #{@responsibility.errors.full_messages.to_sentence}"
      redirect_to employee_path(@employee)
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: "Employee was successfully deleted."
    else
      redirect_to employees_path, alert: "Failed to delete employee."
    end
  end

  def edit_organization
    @employee = Employee.find(params[:id])
    @organizations = Organization.all
  end

  def update_organization
    service = UpdateEmployeeOrganizationService.new(@employee, params[:organization_id])
    if service.call
      redirect_to employee_path(@employee), notice: "Organization updated successfully."
    else
      flash[:alert] = @employee.errors.full_messages.to_sentence
      redirect_to edit_organization_employee_path(@employee)
    end
  end

  def edit_manager
    @employees = Employee.where.not(id: @employee.id) # Exclude the employee being edited
  end

  def update_manager
    if @employee.update(manager_id: params[:manager_id])
      redirect_to employee_path(@employee), notice: "Manager updated successfully."
    else
      flash[:alert] = @employee.errors.full_messages.to_sentence
      redirect_to edit_manager_employee_path(@employee)
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :password, :password_confirmation, :title, :organization_id, :manager_id)
  end

  def responsibility_params
    params.require(:responsibility).permit(:description)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_organization
    @organization = Organization.find(params[:organization_id]) if params[:organization_id].present?
  end

  def set_responsibility
    @responsibility = Responsibility.find(params[:id])
    @employee = @responsibility.employee
  end

  def authorize_employee
    authorize Employee
  end

  def authenticate_admin!
    unless current_employee&.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
