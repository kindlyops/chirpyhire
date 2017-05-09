class CaregiversController < ApplicationController
  decorates_assigned :candidates
  PAGE_LIMIT = 9

  def index
    @candidates = paginated(filtered_candidates).order(id: :desc)
  end

  private

  def filtered_candidates
    return scope unless permitted_params.present?

    scope
      .candidacy_filter(candidacy_params)
      .zipcode_filter(zipcode_params)
  end

  def scope
    policy_scope(Person)
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
    result = permitted_params.to_h.except(:state, :city, :county, :zipcode)
    result[:availability] = (result[:availability] | hourly_params) if hourly?
    result
  end

  def hourly?
    availability? && (am? || pm?)
  end

  def am?
    permitted_params[:availability].include?('hourly_am')
  end

  def pm?
    permitted_params[:availability].include?('hourly_pm')
  end

  def availability?
    permitted_params[:availability].present?
  end

  def hourly_params
    %w(hourly)
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
