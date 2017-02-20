class Subscriber < ApplicationRecord
  belongs_to :person
  belongs_to :organization

  delegate :candidacy, to: :person

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
