class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: %i[index], if: :format_html?
  layout 'candidates', only: %i[index]
  PAGE_LIMIT = 24
  decorates_assigned :candidates

  def index
    respond_to do |format|
      format.html { render html: '', layout: true }
      format.json { @candidates = paginated_candidates }
      format.csv { index_csv }
    end
  end

  private

  def paginated_candidates
    paginated(filtered_candidates.recently_replied)
  end

  def index_csv
    @candidates = filtered_candidates.recently_replied
    @filename = "caregivers-#{DateTime.current.to_i}.csv"
  end

  def filtered_candidates
    return scope if permitted_params.blank?

    scope
      .candidacy_filter(candidacy_params)
      .zipcode_filter(zipcode_params)
      .starred_filter(star_params)
  end

  def scope
    policy_scope(Contact)
  end

  def permitted_params
    params.permit(
      :city, :state, :county, :zipcode, :starred,
      experience: [],
      availability: [],
      transportation: [],
      certification: []
    )
  end

  def star_params
    return {} if params[:starred].blank?

    { starred: true }
  end

  def candidacy_params
    result = permitted_params.to_h.except(
      :state, :city, :county, :zipcode, :starred
    )

    result[:availability] = (result[:availability] | hourly_params) if hourly?
    result = handle_live_in_params(result)
    handle_live_in_or_hourly(result)
  end

  def handle_live_in_params(result)
    return result if result[:availability].blank?
    if result[:availability].include?('live_in')
      result[:live_in] = true
      result[:availability] = result[:availability] - ['live_in']
      result.delete(:availability) if result[:availability].blank?
    end

    result
  end

  def handle_live_in_or_hourly(result)
    return standard_candidacy(result) unless complex_availability?(result)

    availabilities = result[:availability]
                     .map(&method(:enum_availabilities)).compact

    availability_clause(availabilities)
  end

  def availability_clause(availabilities)
    "(\"candidacies\".\"availability\" IN (#{availabilities.join(',')}) OR"\
    ' "candidacies"."live_in" = \'t\')'
  end

  def enum_availabilities(availability)
    Candidacy.availabilities[availability]
  end

  def complex_availability?(result)
    result[:availability].present? && result[:live_in].present?
  end

  def standard_candidacy(result)
    return {} if result.blank?

    { people: { 'candidacies' => result } }
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
    %w[hourly]
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

  def format_html?
    request.format == 'html'
  end

  def page
    params[:page].to_i || 1
  end
end
