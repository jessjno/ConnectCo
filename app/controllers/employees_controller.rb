class EmployeesController < ApplicationController
  before_action :set_organization, only: [:new, :edit, :show, :destroy]
  before_action :set_employee, only: [:show, :edit_responsibility, :update_responsibility, :destroy]
  before_action :authorize_employee, only: [:index, :show, :edit, :update, :destroy, :upload_csv]
  after_action :verify_authorized, except: [:show]

  def sign_in
    if current_employee
      redirect_to root_path
    end
  end

  def new
    @employee = Employee.new
    @organization = Organization.find(params[:organization_id])
    authorize @employee
  end

  def create
    @employee = Employee.new(employee_params)
    authorize @employee

    @employee.skip_confirmation_notification! if @employee.respond_to?(:skip_confirmation_notification!)

    if @employee.save
      redirect_to organization_path(@employee.organization_id), notice: "Employee created successfully."
    else
      render :new, alert: "Failed to create employee."
    end
  end

  def index
    authorize Employee
    @q = Employee.ransack(params[:q])
    @employees = @q.result.includes(:organization).order(:last_name)
  end

  def show
    @employee = Employee.find(params[:id])
    @responsibilities = @employee.responsibilities
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
    @responsibility = Responsibility.find(params[:id])
    authorize @responsibility
  end

  def update_responsibility
    @responsibility = Responsibility.find(params[:id])
    authorize @responsibility

    if @responsibility.update(responsibility_params)
      @responsibility.save
      redirect_to employee_path(@responsibility.employee), notice: "Responsibility updated successfully."
    else
      render :edit_responsibility, alert: "Failed to update responsibility."
    end
  end

  def destroy
    authorize @employee

    if @employee.destroy
      redirect_to organization_path(@organization), notice: "Employee was successfully deleted."
    else
      redirect_to organization_path(@organization), alert: "Failed to delete employee."
    end
  end

  def upload_csv
    if params[:file].present?
      file = params[:file]

      begin
        CSV.foreach(file.path, headers: true) do |row|
          employee_data = row.to_hash

          Employee.find_or_create_by(email: employee_data["email"]) do |employee|
            employee.first_name = employee_data["first_name"]
            employee.last_name = employee_data["last_name"]
            employee.title = employee_data["title"]
            employee.organization_id = employee_data["organization_id"]
            employee.member_id = employee_data["member_id"]
            employee.password = employee_data["password"]
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

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :password, :password_confirmation, :title, :organization_id, :member_id, :manager_id)
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

  def authorize_employee
    authorize Employee
  end
end
