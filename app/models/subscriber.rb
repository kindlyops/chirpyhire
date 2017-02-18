class Subscriber < ApplicationRecord
  belongs_to :person
  belongs_to :organization

  def unsubscribe!
    update!(subscribed: false)
  end
end
