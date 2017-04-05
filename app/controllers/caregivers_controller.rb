class CaregiversController < ApplicationController
  decorates_assigned :candidates
  PAGE_LIMIT = 9

  def index
    @candidates = paginated(filtered_candidates)
  end

  private

  def filtered_candidates
    return scope unless permitted_params.present?
    scope.filter(permitted_params)
  end

  def scope
    policy_scope(Contact)
  end

  def permitted_params
    params.permit(
      experience: [],
      availability: [],
      transportation: [],
      certification: []
    )
  end

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end
end
