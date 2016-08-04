class DogPolicy < ApplicationPolicy

  def update?
    true
  end

  def permitted_attributes
    [:name, toys_attributes: [:id, :_destroy, :name]]
  end
end
