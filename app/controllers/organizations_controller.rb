class OrganizationsController < ApplicationController
  include Pundit
  before_action :set_organization, only: [:edit, :update, :show, :destroy]
  def index
    @organizations = Organization.order(:id)
    render({ :template => "organizations/index" })
  end
  
  def show
    @organization = Organization.includes(:employees, :sub_organizations).find(params[:id])
    authorize @organization
    @employees = @organization.employees
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    if @organization.valid?
      @organization.save
      redirect_to("/organizations", { :notice => "Organization created successfully." })
    else
      redirect_to("/organizations", { :alert => @organization.errors.full_messages.to_sentence })
    end
  end

  def update
    @organization = Organization.find(params[:id])
    authorize @organization
    if @organization.update(organization_params)
      @organization.save
      redirect_to("/organizations/#{@organization.id}", { :notice => "Organization updated successfully."} )
    else
      redirect_to("/organizations/#{@organization.id}", { :alert => @organization.errors.full_messages.to_sentence })
    end
  end

  def destroy
    @organization = Organization.find(params[:id])

    @organization.destroy

    redirect_to("/organizations", { :notice => "Organization deleted successfully."} )
  end

  
  private

  def set_organization  
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :parent_id, :employees_count)
  end
end
