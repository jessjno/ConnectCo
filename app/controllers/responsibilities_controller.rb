class ResponsibilitiesController < ApplicationController
  def index
    matching_responsibilities = Responsibility.all

    @list_of_responsibilities = matching_responsibilities.order({ :created_at => :desc })

    render({ :template => "responsibilities/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_responsibilities = Responsibility.where({ :id => the_id })

    @the_responsibility = matching_responsibilities.at(0)

    render({ :template => "responsibilities/show" })
  end

  def create
    the_responsibility = Responsibility.new
    the_responsibility.name = params.fetch("query_name")
    the_responsibility.description = params.fetch("query_description")
    the_responsibility.employee_id = params.fetch("query_employee_id")

    if the_responsibility.valid?
      the_responsibility.save
      redirect_to("/responsibilities", { :notice => "Responsibility created successfully." })
    else
      redirect_to("/responsibilities", { :alert => the_responsibility.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_responsibility = Responsibility.where({ :id => the_id }).at(0)

    the_responsibility.name = params.fetch("query_name")
    the_responsibility.description = params.fetch("query_description")
    the_responsibility.employee_id = params.fetch("query_employee_id")

    if the_responsibility.valid?
      the_responsibility.save
      redirect_to("/responsibilities/#{the_responsibility.id}", { :notice => "Responsibility updated successfully."} )
    else
      redirect_to("/responsibilities/#{the_responsibility.id}", { :alert => the_responsibility.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_responsibility = Responsibility.where({ :id => the_id }).at(0)

    the_responsibility.destroy

    redirect_to("/responsibilities", { :notice => "Responsibility deleted successfully."} )
  end
end
