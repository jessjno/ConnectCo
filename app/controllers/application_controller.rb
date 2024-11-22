class ApplicationController < ActionController::Base
  # todo: uncomment later
  before_action :authenticate_employee!
  skip_forgery_protection

  helper_method :current_employee
end
