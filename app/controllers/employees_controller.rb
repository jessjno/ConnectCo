class EmployeesController < ApplicationController
  before_action :set_organization, only: [:new, :edit, :show, :destroy]
  before_action :set_employee, only: [:show, :edit_responsibility, :update_responsibility, :destroy]
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

    if @employee.save
      redirect_to organization_path(@employee.organization_id), notice: "Employee created successfully."
    else
      render :new, alert: "Failed to create employee."
    end
  end


  def show
    @current_employee = current_employee

    @employee = Employee.find(params[:id])
    @organization = @employee.organization
    @responsibilities = @employee.responsibilities
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
      redirect_to employee_path(@responsibility.employee), notice: 'Responsibility updated successfully.'
    else
      render :edit_responsibility, alert: 'Failed to update responsibility.'
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
end
