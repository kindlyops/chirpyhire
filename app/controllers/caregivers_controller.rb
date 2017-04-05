class CaregiversController < ApplicationController
  decorates_assigned :candidates
  PAGE_LIMIT = 9

  def index
    @candidates = paginated(policy_scope(Contact))
  end

  private

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end
end
