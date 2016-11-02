class CandidatesController < ApplicationController
  include ActionController::Live
  decorates_assigned :candidates, :candidate

  def show
    respond_to do |format|
      format.geojson do
        @candidate = authorized_candidate.decorate
        render json: GeoJson.build_sources([@candidate], state_data)
      end

      format.html do
        @candidate = authorized_candidate
      end
    end
  end

  def index
    respond_to do |format|
      format.geojson do
        @candidates = recent_candidates
        render json: GeoJson.build_sources(@candidates, state_data)
      end

      format.html do
        @zipcodes = zipcodes
        @candidates = filtered_and_paged_candidates
      end
    end
  end

  def stream_test
    skip_authorization
    begin
      geo_json = GeoJson::Zipcode.new(recent_candidates, nil)
      expires_in 30.days, public: true
      response.headers['Content-Type'] = 'text/event-stream'
      stuff = geo_json.dumb(params["zipcode"])
      IO::copy_stream(stuff, response.stream)
    rescue Exception => e
      puts e.message
    ensure
      response.stream.close
    end
  end


  def edit
    @candidates = filtered_and_paged_candidates
    @candidate = authorized_candidate
    @zipcodes = zipcodes
    render :index
  end

  def update
    if authorized_candidate.update(permitted_attributes(Candidate))
      redirect_to candidates_url, notice: 'Nice! '\
      "#{authorized_candidate.handle} marked \
      as #{authorized_candidate.stage.name}"
    else
      redirect_to candidates_url, alert: "Oops! Couldn't change "\
      "the candidate's status"
    end
  end

  def state_data
    @state_data ||= GeoJson::StateData.new
  end

  private

  def zipcodes
    zipcode_feature_zips = recent_candidates.map(&:zipcode)
    address_feature_zips = recent_candidates.map { |c| c.address&.zipcode }
    zips = zipcode_feature_zips.concat(address_feature_zips).compact
                               .map { |f| f[0..4] }
                               .uniq
                               .sort
    [CandidateFeature::ALL_ZIPCODES_CODE].concat(zips)
  end

  def filtered_and_paged_candidates
    recent_candidates.filter(filtering_params).page(params.fetch(:page, 1))
  end

  def authorized_candidate
    authorize Candidate.find(params[:id])
  end

  def recent_candidates
    @recent_candidates ||=
      policy_scope(Candidate).by_recency.includes(:candidate_features, :user)
                             .references(:candidate_features, :user)
  end

  def filtering_params
    { created_in: created_in, stage_name: stage_name, zipcode: zipcode }
  end

  def created_in
    cookied_query_param(
      :created_in,
      :candidate_created_in_filter,
      'Past Week'
    )
  end

  def stage_name
    cookied_query_param(
      :stage_name,
      :candidate_stage_filter,
      current_organization.default_display_stage.name
    )
  end

  def zipcode
    cookied_query_param(
      :zipcode,
      :candidate_zipcode_filter,
      CandidateFeature::ALL_ZIPCODES_CODE
    )
  end

  def cookied_query_param(param_sym, cookie_sym, default)
    value = params[param_sym]
    if value.present?
      cookies[cookie_sym] = cookie(value)
    elsif cookies[cookie_sym].blank?
      cookies[cookie_sym] = cookie(default)
    end
    cookies[cookie_sym]
  end

  def cookie(value)
    { value: value }
  end
end
