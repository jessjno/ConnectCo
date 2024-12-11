class ResponsibilityDeletionService
  def initialize(responsibility)
    @responsibility = responsibility
  end

  def call
    if @responsibility.destroy
      true
    else
      false
    end
  end
end
