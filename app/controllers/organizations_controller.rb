class OrganizationsController < ApplicationController
  include Pundit
  before_action :set_organization, only: [:edit, :update, :show, :destroy]

  def index
    @organizations = Organization.order(:id)
    render({ :template => "organizations/index" })
  end

  def show
    authorize @organization
    @employees = @organization.employees
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    if @organization.save
      redirect_to organizations_path, notice: "Organization was successfully created."
    else
      render :new, alert: @organization.errors.full_messages.to_sentence
    end
  end

  def update
    authorize @organization
    if @organization.update(organization_params)
      redirect_to organization_path(@organization), notice: "Organization updated successfully."
    else
      render :edit, alert: @organization.errors.full_messages.to_sentence
    end
  end

  def destroy
    authorize @organization
    if @organization.destroy
      redirect_to organizations_path, notice: "Organization was successfully deleted."
    else
      redirect_to organizations_path, alert: "Failed to delete organization."
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
    authorize @organization
  end

  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
