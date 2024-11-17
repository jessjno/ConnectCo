class EmployeesController < ApplicationController
  before_action :authenticate_employee!, only: [:dashboard]

  def sign_in
    if current_employee
      redirect_to root_path
    end

  def show
    @employee = current_employee
  end

  def edit
    @employee = current_employee
  end

  def update
    @employee = current_employee
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
