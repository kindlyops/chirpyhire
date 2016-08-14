class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :organization

  validates_presence_of :plan, :quantity, on: :create
end
