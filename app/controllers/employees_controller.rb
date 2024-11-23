class EmployeesController < ApplicationController
  #before_action :authenticate_employee!, only: [:dashboard]
  before_action :set_employee, only: [:show]
  after_action :verify_authorized, except: [:show]

  def sign_in
    if current_employee
      redirect_to root_path
    end
  end

  def show
    @current_employee = current_employee

    @employee = Employee.find(params[:id])
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


  private

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :password_confirmation)
  end

  def responsibility_params
    params.require(:responsibility).permit(:description)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
