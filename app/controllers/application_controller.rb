class ApplicationController < ActionController::Base
  include Pundit::Authorization
  helper Pundit::Authorization

  before_action :authenticate_employee!
  skip_forgery_protection


  helper_method :current_employee
  
  rescue_from Pundit::NotAuthorizedError, with: :employee_not_authorized

  private

  def pundit_user
    current_employee
  end


  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back fallback_location: root_url
  end
end
