class OrganizationsController < ApplicationController
  def index
    organizations = Organization.all
    @organization_tree = Organization.build_tree(organizations)

    render({ :template => "organizations/index" })
  end

  def show
  @organization = Organization.find(params[:id])
  employees = @organization.employees.includes(:member) # Eager load members for performance

  @employee_hierarchy = build_employee_hierarchy(employees)
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

  # def org_chart_data
  #   # data = build_tree(Organization.all)
  #   # render json: data
    
  #   # organizations = Organization.all
  #   # render json: organizations.as_json(only: [:id, :name, :parent_id])
  # end
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
    # Fetch managers and non-managers using Active Record queries
    managers = employees.joins(:member).where(members: { role: 'manager' })
    non_managers = employees.joins(:member).where(members: { role: 'employee' })
  
    # Return an empty hierarchy if no managers are found
    return [] if managers.empty?
  
    # Build the hierarchy
    hierarchy = managers.map do |manager|
      {
        id: manager.id,
        name: "#{manager.first_name} #{manager.last_name}",
        title: manager.title,
        subordinates: non_managers.map do |employee|
          {
            id: employee.id,
            name: "#{employee.first_name} #{employee.last_name}",
            title: employee.title
          }
        end
      }
    end
  
    hierarchy
  end
  
end
