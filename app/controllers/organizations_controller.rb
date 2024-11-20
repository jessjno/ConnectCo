class OrganizationsController < ApplicationController
  def index
    organizations = Organization.all
    @organization_tree = Organization.build_tree(organizations)

    render({ :template => "organizations/index" })
  end

  def show
  @organization = Organization.find(params[:id])
  # employees = @organization.employees.includes(:member) 
  @employees = @organization.employees
  @employee_hierarchy = build_employee_hierarchy(@employees)
  end

  def create
    the_organization = Organization.new
    the_organization.name = params.fetch("query_name")
    the_organization.description = params.fetch("query_description")
    the_organization.parent_id = params.fetch("query_parent_id")
    the_organization.employees_count = params.fetch("query_employees_count")

    if the_organization.valid?
      the_organization.save
      redirect_to("/organizations", { :notice => "Organization created successfully." })
    else
      redirect_to("/organizations", { :alert => the_organization.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_organization = Organization.where({ :id => the_id }).at(0)

    the_organization.name = params.fetch("query_name")
    the_organization.description = params.fetch("query_description")
    the_organization.parent_id = params.fetch("query_parent_id")
    the_organization.employees_count = params.fetch("query_employees_count")

    if the_organization.valid?
      the_organization.save
      redirect_to("/organizations/#{the_organization.id}", { :notice => "Organization updated successfully."} )
    else
      redirect_to("/organizations/#{the_organization.id}", { :alert => the_organization.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_organization = Organization.where({ :id => the_id }).at(0)

    the_organization.destroy

    redirect_to("/organizations", { :notice => "Organization deleted successfully."} )
  end

  def org_chart_data
    organizations = Organization.all
    Rails.logger.info(organizations.to_json)
    render json: organizations.as_json(only: [:id, :name, :parent_id])
  end
  
  private

  def build_tree(nodes)
    nodes = nodes.map { |org| org.attributes.symbolize_keys }
    id_map = nodes.index_by { |node| node[:id] }
    root = []

    nodes.each do |node|
      if node[:parent_id].nil?
        root << node
      else
        parent = id_map[node[:parent_id]]
        parent[:children] ||= []
        parent[:children] << node
      end
    end

    root
  end

  def build_employee_hierarchy(employees)
    # Create a hash of employees indexed by their ID
    id_map = employees.index_by(&:id)

    # Create the root array to hold the top-level employees (managers)
    hierarchy = []

    employees.each do |employee|
      if employee.manager_id.nil?  # Top-level managers (no manager)
        hierarchy << build_employee_tree(employee, id_map)
      end
    end

    hierarchy
  end

  def build_employee_tree(employee, id_map)
    # Create a node for the current employee
    employee_node = employee.attributes.symbolize_keys
    employee_node[:children] = []

    # Find subordinates (children) and build their tree
    employee.subordinates.each do |subordinate|
      employee_node[:children] << build_employee_tree(subordinate, id_map)
    end

    employee_node
  end

end
