class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy, :edit_responsibility, :update_responsibility, :edit_organization, :update_organization, :edit_manager, :update_manager]
  before_action :authorize_employee, only: [:index, :show, :edit, :update, :destroy, :upload_csv]
  before_action :authenticate_admin!, only: [:new, :create]
  before_action :set_responsibility, only: [:edit_responsibility, :update_responsibility]
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

  def create
    @employee = Employee.new(employee_params)
    authorize @employee

    if @employee.save
      redirect_to employees_path, notice: "Employee created successfully."
    else
      render :new, alert: "Failed to create employee."
    end
  end

  def index
    @q = Employee.ransack(params[:q])
    @employees = @q.result.includes(:organization).order(:last_name).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @q = Employee.ransack(params[:q])
    @employee = Employee.find(params[:id])
    @responsibilities = @employee.responsibilities
    @responsibility = Responsibility.new
    authorize @employee
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
    authorize @employee
    if @employee.destroy
      redirect_to employees_path, notice: "Employee was successfully deleted."
    else
      redirect_to employees_path, alert: "Failed to delete employee."
    end
  end

  def upload_csv
    if params[:file].present?
      file = params[:file]

      begin
        CSV.foreach(file.path, headers: true) do |row|
          employee_data = row.to_hash

          Employee.find_or_create_by(email: employee_data["email"]) do |employee|
              employee.update(employee_data.slice("first_name", "last_name", "title", "organization_id", "password", "image_url"))
          end
        end

        redirect_to employees_path, notice: "Employees uploaded successfully."
      rescue StandardError => e
        redirect_to employees_path, alert: "Error processing CSV: #{e.message}"
      end
    else
      redirect_to employees_path, alert: "Please upload a valid CSV file."
    end
  end

  def edit_organization
    @employee = Employee.find(params[:id])
    @organizations = Organization.all
    authorize @employee, :edit_organization?
  end

  def update_organization
    @employee = Employee.find(params[:id])
    authorize @employee, :update_organization?
    new_organization_id = params[:organization_id]

    if @employee.update(organization_id: new_organization_id)
      redirect_to employee_path(@employee), notice: "Organization updated successfully."
    else
      flash[:alert] = @employee.errors.full_messages.to_sentence
      redirect_to edit_organization_employee_path(@employee)
    end
  end

  def edit_manager
    authorize @employee
    @employees = Employee.where.not(id: @employee.id) # Exclude the employee being edited
  end

  def update_manager
    authorize @employee
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
