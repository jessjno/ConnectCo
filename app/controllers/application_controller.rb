class ApplicationController < ActionController::Base
  include Pundit::Authorization
  helper Pundit::Authorization

  before_action :authenticate_employee!
  before_action :initialize_search
  skip_forgery_protection

  helper_method :current_employee

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def pundit_user
    current_employee
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def initialize_search
    @employee_q = Employee.ransack(params[:q])
  end
end
