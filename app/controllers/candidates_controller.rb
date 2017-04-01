class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, if: :html?
  decorates_assigned :candidates

  def index
    respond_to do |format|
      format.html
      format.json { @candidates = selected(paginated(ordered_candidates)) }
      format.csv { index_csv }
    end
  end

  private

  def index_csv
    @candidates = selected(paginated(ordered_candidates))
    @filename = filename
  end

  def filename
    "candidates-#{DateTime.current.to_i}.csv"
  end

  def paginated(scope)
    if params[:offset].present? && params[:limit].present?
      scope.page(page).per(limit)
    else
      scope
    end
  end

  def selected(scope)
    if params[:id].present?
      scope.where(id: params[:id])
    else
      scope
    end
  end

  def ordered(scope)
    scope.includes(person: :candidacy).order(order)
  end

  def ordered_candidates
    ordered(policy_scope(scoped_contacts))
  end

  def scoped_contacts
    if params[:search].present?
      Contact.candidate.search_candidates(params[:search])
    else
      Contact.candidate
    end
  end

  def limit
    params[:limit].to_i
  end

  def offset
    params[:offset].to_i
  end

  def page
    ((offset / limit) + 1).round
  end

  def direction
    params[:order]
  end

  def order
    return { id: :asc } unless sorting?
    "#{whitelist_orders[params[:sort]]}#{stabilizer}"
  end

  def filter_options
    [:zipcode, :availability, :certification, :experience, :transportation]
  end

  def filtered_order
    filters = filter_options.select { |f| params[f].present? }
    return { id: :asc } unless filters.present?

    case_clause = "CASE"
    filters.count.times do |time|
      when_fragment = " WHEN ("
      combinations = filters.combination(filters.count - time)

      combinations.each_with_index do |combination, c_index|
        combination.each_with_index do |filter, f_index|
          filter_fragment = " candidacies.#{filter}='#{filter_mapping(filter)}'"
          if f_index < combination.count - 1
            filter_fragment << " AND"
          elsif f_index == (combination.count - 1) && (c_index < combinations.count - 1)
            filter_fragment << ") OR ("
          else
            filter_fragment << ") THEN #{time}"
          end

          when_fragment << filter_fragment
        end
      end

      when_fragment << " ELSE #{time + 1} END as match" if time == (filters.count - 1)
      case_clause << when_fragment
    end


  end

  def filter_mapping(filter)
    return params[filter] if filter == :zipcode
    Candidacy.send(filter.to_s.pluralize)[params[filter]]
  end

  def sorting?
    params[:sort].present? && whitelist_orders[params[:sort]].present?
  end

  def stabilizer
    ',contacts.id ASC'
  end

  def whitelist_orders
    {
      'zipcode' => "candidacies.zipcode #{direction}",
      'contact' =>  "people.phone_number #{direction}",
      'availability' => "candidacies.availability #{direction}",
      'experience' => "candidacies.experience #{direction}",
      'qualifications' => "candidacies.certification #{direction}",
      'status' => "subscribed #{direction}",
      'screened' => "screened #{direction}"
    }
  end

  def html?
    request.format.html?
  end
end
