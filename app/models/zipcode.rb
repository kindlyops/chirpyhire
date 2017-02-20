class Zipcode < ApplicationRecord
  belongs_to :ideal_candidate, inverse_of: :zipcodes
  validates :value, length: { is: 5 }
  validate :us_zipcode

  private

  def us_zipcode
    return if ZipCodes.identify(value).present?
    errors.add(:zipcode, 'must be a valid U.S. zipcode.')
  end
end
