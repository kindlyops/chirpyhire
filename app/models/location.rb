class Location < ApplicationRecord
  belongs_to :team
  belongs_to :organization, optional: true

  def organization
    super || team.organization
  end

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :state_code, length: { is: 2 }
  validates :postal_code, length: { minimum: 5 }

  def zipcode
    postal_code
  end
end
