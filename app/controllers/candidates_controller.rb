class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: %i[index], if: :format_html?
  layout 'react', only: %i[index]
  PAGE_LIMIT = 24
  decorates_assigned :candidates

  def new
    @candidate = authorize(scope.build)
  end

  def create
    @candidate = authorize(scope.build(permitted_attributes(Contact)))

    if @candidate.valid?
      @candidate.person = Person.create
      @candidate.subscribed = true
      @candidate.save
      IceBreaker.call(@candidate, current_organization.phone_numbers.first)
      redirect_to candidates_path
    else
      render :new
    end
  end

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
      .contact_stage_filter(contact_stage_params)
      .campaigns_filter(campaigns_params)
      .name_filter(name_params)
      .tag_filter(tag_params)
      .zipcode_filter(zipcode_params)
      .messages_filter(messages_params)
  end

  def scope
    policy_scope(Contact)
  end

  def permitted_params
    params.permit(*permitted_params_keys)
  end

  def permitted_params_keys
    %i[city state county zipcode name messages]
      .concat([tag: [], contact_stage: [], campaigns: []])
  end

  def campaigns_params
    permitted_params.to_h[:campaigns]
  end

  def messages_params
    permitted_params.to_h[:messages]
  end

  def name_params
    permitted_params.to_h[:name]
  end

  def tag_params
    permitted_params.to_h[:tag]
  end

  def contact_stage_params
    permitted_params.to_h[:contact_stage]
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
