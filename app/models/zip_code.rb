class ZipCode < ApplicationRecord
  belongs_to :ideal_candidate
  validates :value, length: { is: 5 }
end
