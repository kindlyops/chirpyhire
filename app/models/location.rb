# frozen_string_literal: true
class Location < ApplicationRecord
  belongs_to :organization

  validates :state, length: { is: 2 }
  validates :state_code, length: { is: 2 }
end
