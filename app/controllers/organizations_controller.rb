class OrganizationsController < ApplicationController
  include Pundit
  include CsvUploadable
  before_action :set_organization, only: [:edit, :update, :show, :destroy]

  def index
    @q = Employee.ransack(params[:q])
    @organizations = Organization.all
  end

  def show
    authorize @organization
    @employees = @organization.all_employees
    @sub_organizations = @organization.all_sub_organizations
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def upload_csv
    upload_csv_logic(params[:file], "organization")
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

  def edit
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
    @organization = Organization.find(params[:id])
    if @organization.destroy
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
