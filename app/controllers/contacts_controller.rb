class ContactsController < ApplicationController
  skip_after_action :verify_policy_scoped, if: :html?
  decorates_assigned :contacts

  def index
    respond_to do |format|
      format.html
      format.json { @contacts = selected(paginated(ordered_contacts)) }
      format.csv { index_csv }
    end
  end

  private

  def index_csv
    @contacts = selected(paginated(ordered_contacts))
    @filename = filename
  end

  def filename
    "contacts-#{DateTime.current.to_i}.csv"
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

  def ordered_contacts
    ordered(policy_scope(scoped_contacts))
  end

  def scoped_contacts
    if params[:search].present?
      Contact.not_ready.search_not_ready(params[:search])
    else
      Contact.not_ready
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

  def sorting?
    params[:sort].present? && whitelist_orders[params[:sort]].present?
  end

  def stabilizer
    ',contacts.id ASC'
  end

  def whitelist_orders
    {
      'nickname' => "people.nickname #{direction}",
      'created_at' => "contacts.created_at #{direction}",
      'survey_progress' => "candidacies.progress #{direction}",
      'last_reply_at' => "contacts.last_reply_at #{direction}",
      'temperature' => "contacts.last_reply_at #{direction}"
    }
  end

  def html?
    request.format.html?
  end
end
