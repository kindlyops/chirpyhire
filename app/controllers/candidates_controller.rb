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
      Contact.candidate.search(params[:search])
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
    offset / limit
  end

  def direction
    params[:order]
  end

  def order
    return { id: :asc } unless params[:sort].present?
    return { id: :asc } unless whitelist_orders[params[:sort]].present?
    "#{whitelist_orders[params[:sort]]}#{stabilizer}"
  end

  def stabilizer
    ',id ASC'
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
