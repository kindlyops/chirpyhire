# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AddressQuestionOption, type: :model do
  it { should validate_numericality_of(:distance).is_greater_than(0) }
  it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90) }
  it { should validate_numericality_of(:latitude).is_less_than_or_equal_to(90) }

  it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180) }
  it { should validate_numericality_of(:longitude).is_less_than_or_equal_to(180) }
end
