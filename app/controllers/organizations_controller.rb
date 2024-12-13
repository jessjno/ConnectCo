class OrganizationsController < ApplicationController
  include Pundit
  include CsvUploadable
  before_action :set_organization, only: [:edit, :update, :show, :destroy]

  def index
    @q = Employee.ransack(params[:q])
    @q_organization = Organization.ransack(params[:q])

    @organizations = @q_organization.result.ordered_by_parent.page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @organization = Organization.with_sub_organizations_and_employees.find(params[:id])
    @employees = @organization.employees
    @sub_organizations = @organization.sub_organizations
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def upload_csv
    upload_csv_logic(params[:file], "organization")
  end

  def create
    service = OrganizationCreationService.new(organization_params)
    @organization = service.call

    if @organization
      redirect_to organizations_path, notice: "Organization was successfully created."
    else
      render :new, alert: "Failed to create organization."
    end
  end

  def edit
  end

  def update
    service = OrganizationUpdateService.new(@organization, organization_params)
    @organization = service.call

    if @organization && @organization.errors.empty?
      redirect_to organization_path(@organization), notice: "Organization updated successfully."
    else
      
      if @organization.nil?
        @organization = Organization.find(params[:id]) 
      end
      render :edit, alert: @organization.errors.full_messages.to_sentence
    end
  end

  def destroy
    service = OrganizationDeletionService.new(@organization)
    if service.call
      flash[:success] = "Organization successfully deleted."
    else
      flash[:error] = @organization.errors.full_messages.to_sentence
    end
    redirect_to organizations_path
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
    authorize @organization
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :parent_id)
  end
end
