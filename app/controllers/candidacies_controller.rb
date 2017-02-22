class CandidaciesController < ApplicationController
  decorates_assigned :candidacies

  def index
    @candidacies = ordered_candidacies.page(page).per(limit)

    respond_to do |format|
      format.json
    end
  end

  private

  def ordered_candidacies
    policy_scope(Candidacy).joins(person: :subscribers).order(order)
  end

  def limit
    params[:limit].to_i
  end

  def page
    params[:offset].to_i / limit
  end

  def direction
    params[:order]
  end

  def order
    return { id: :asc } unless params[:sort].present?
    "#{whitelist_orders[params[:sort]]}#{stabilizer}"
  end

  def stabilizer
    ",id ASC"
  end

  def whitelist_orders
    {
      'zipcode' => "zipcode #{direction}",
      'contact' =>  "people.phone_number #{direction}",
      'availability' => "availability #{direction}",
      'experience' => "experience #{direction}",
      'qualifications' => "certification #{direction}",
      'status' => "subscribers.subscribed #{direction}"
    }
  end
end
