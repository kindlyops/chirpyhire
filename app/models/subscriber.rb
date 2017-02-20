class Subscriber < ApplicationRecord
  belongs_to :person
  belongs_to :organization

  delegate :candidacy, :handle, :zipcode, :phone_number, to: :person

  def self.active
    where(subscribed: true)
  end

  def unsubscribe!
    update!(subscribed: false)
  end

  def ideal?
    candidacy.ideal?(organization.ideal_candidate)
  end

  def promising?
    !ideal?
  end
end
