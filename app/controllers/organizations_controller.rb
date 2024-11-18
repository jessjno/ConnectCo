class OrganizationsController < ApplicationController
  def index
    organizations = Organization.all
    @organization_tree = Organization.build_tree(organizations)

    render({ :template => "organizations/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_organizations = Organization.where({ :id => the_id })

    @the_organization = matching_organizations.at(0)

    render({ :template => "organizations/show" })
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
end
