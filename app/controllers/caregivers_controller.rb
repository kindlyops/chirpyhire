class CaregiversController < ApplicationController
  decorates_assigned :candidates
  PAGE_LIMIT = 9

  def index
    @candidates = paginated(filtered_candidates).order(id: :asc)
  end

  private

  def filtered_candidates
    return scope unless permitted_params.present?

    scope
      .candidacy_filter(candidacy_params)
      .zipcode_filter(zipcode_params)
  end

  def scope
    policy_scope(Contact)
  end

  def permitted_params
    params.permit(
      :city, :state, :county, :zipcode,
      experience: [],
      availability: [],
      transportation: [],
      certification: []
    )
  end

  def candidacy_params
    permitted_params.to_h.except(:state, :city, :county, :zipcode)
  end

  def zipcode_params
    result = permitted_params.to_h.slice(:state, :city, :county, :zipcode)
    result[:county_name]        = result.delete(:county) if result[:county]
    result[:default_city]       = result.delete(:city)   if result[:city]
    result[:state_abbreviation] = result.delete(:state)  if result[:state]

    result
  end

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end
end
