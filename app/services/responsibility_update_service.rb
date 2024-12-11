class ResponsibilityUpdateService
  def initialize(responsibility, responsibility_params)
    @responsibility = responsibility
    @responsibility_params = responsibility_params
  end

  def call
    if @responsibility.update(@responsibility_params)
      @responsibility
    else
      nil
    end
  end
end
