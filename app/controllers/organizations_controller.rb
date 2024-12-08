class OrganizationsController < ApplicationController
  include Pundit
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

  def upload_csv
    if params[:file].present?
      file = params[:file]
      
      begin
        CSV.foreach(file.path, headers: true) do |row|
          organization_data = row.to_hash
  
          Organization.find_or_create_by(id: organization_data["id"]) do |organization|
            organization.update(organization_data.slice("name", "description", "parent_id"))
          end
        end
  
        redirect_to organizations_path, notice: "CSV data uploaded successfully."
      rescue StandardError => e
        redirect_to organizations_path, alert: "Error processing CSV: #{e.message}"
      end
    else
      redirect_to organizations_path, alert: "Please upload a valid CSV file."
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
