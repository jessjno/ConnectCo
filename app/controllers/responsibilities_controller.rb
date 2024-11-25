class ResponsibilitiesController < ApplicationController
  before_action :set_responsibility, only: [:edit, :update, :destroy]
  before_action :authorize_responsibility, only: [:edit, :update, :destroy]
  before_action :ensure_employee_is_authorized, only: [:edit, :update, :destroy]
  
  def index
    @list_of_responsibilities = Responsibility.order(created_at: :desc)
    @responsibility = Responsibility.new
    render({ :template => "responsibilities/index" })
  end

  def show
    @responsibility = Responsibility.find(params[:id])
    render({ :template => "responsibilities/show" })
  end
 

  def create
    @responsibility = Responsibility.new(responsibility_params)
    @responsibility.employee_id = current_employee.id
    
    if @responsibility.save
      authorize @responsibility
      redirect_to employee_path(@responsibility.employee), notice: "Responsibility created successfully."
    else
      redirect_to employee_path(@responsibility.employee), alert: @responsibility.errors.full_messages.to_sentence
    end
  end

  def edit
    @responsibility
  end

  def update
    @responsibility = Responsibility.find(params[:id])
    authorize @responsibility

    if @responsibility.update(responsibility_params)
      redirect_to employee_path(@responsibility.employee), notice: "Responsibility updated successfully."
    else
      render :edit, alert: 'Failed to update responsibility.'
    end
  end

  def destroy
    if @responsibility.destroy
      redirect_to responsibilities_path, notice: "Responsibility deleted successfully."
    else
      redirect_to responsibilities_path, alert: "Failed to delete responsibility."
    end
  end

  private

  def responsibility_params
    params.require(:responsibility).permit(:description, :employee_id)
  end

  def set_responsibility
    @responsibility = Responsibility.find(params[:id])
  end

  def authorize_responsibility
    authorize @responsibility
  end

  def ensure_employee_is_authorized
    if @responsibility.nil? || !ResponsibilityPolicy.new(current_employee, @responsibility).show?
      raise Pundit::NotAuthorizedError, "Not allowed"
    end
  end
end
