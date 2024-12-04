module ResponsibilitiesManagement
  extend ActiveSupport::Concern

  included do
    has_many :responsibilities
    validates :description, presence: true
  end

  def add_responsibility(description)
    responsibilities.create(description: description)
  end

  def remove_responsibility(responsibility)
    responsibility.destroy
  end
end
