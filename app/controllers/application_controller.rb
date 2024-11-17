class ApplicationController < ActionController::Base
  before_action :authenticate_employee!
  skip_forgery_protection

  helper_method :current_employee
end
