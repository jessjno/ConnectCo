class SearchController < ApplicationController
  def results
    @employees = Employee.ransack(params[:q]).result

    respond_to do |format|
      format.html { render partial: 'employees/results', locals: { employees: @employees } }
      format.js
    end
  end
end
