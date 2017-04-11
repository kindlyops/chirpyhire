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
    z_params = permitted_params.to_h.slice(:state, :city, :county, :zipcode)
    z_params[:county_name] = z_params[:county] if z_params[:county]
    z_params[:default_city] = z_params[:city] if z_params[:city]
    z_params[:state_abbreviation] = z_params[:state] if z_params[:state]

    z_params.except(:county, :city, :state)
  end

  def paginated(scope)
    scope.page(page).per(PAGE_LIMIT)
  end

  def page
    params[:page].to_i || 1
  end
end
