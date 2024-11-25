class SearchController < ApplicationController
  def results
    @employees = Employee.ransack(params[:q]).result
    @organizations = Organization.ransack(params[:organization_q]).result
  end
end
