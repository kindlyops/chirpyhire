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
    scope.joins(person: :candidacy).order(order)
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

  def order
    Contact::Filterer.new(params).order
  end

  def html?
    request.format.html?
  end
end
