class CandidatesController < ApplicationController
  skip_after_action :verify_policy_scoped, if: :html?
  decorates_assigned :candidates

  def index
    respond_to do |format|
      format.html
      format.json { @candidates = fetch_candidates }
      format.csv { index_csv }
    end
  end

  private

  def index_csv
    @candidates = fetch_candidates
    @filename = filename
  end

  def fetch_candidates
    if params[:search].present?
      selected(paginate(policy_scope(searched_candidates)))
    else
      selected(paginate(ordered_candidates))
    end
  end

  def filename
    "candidates-#{DateTime.current.to_i}.csv"
  end

  def paginate(scope)
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

  def searched_candidates
    scoped_contacts.search(params[:search])
  end

  def ordered_candidates
    policy_scope(scoped_contacts).joins(person: :candidacy).order(order)
  end

  def scoped_contacts
    Contact.candidate
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
