class EmployeesController < ApplicationController
  before_action :authenticate_employee!, only: [:dashboard]

  def sign_in
    if current_employee
      redirect_to root_path
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

  private

  def employee_params
    params.require(:employee).permit(:name, :email, :password, :password_confirmation)
  end
end
