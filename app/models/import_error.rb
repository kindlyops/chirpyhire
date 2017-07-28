class ImportError < ApplicationRecord
  belongs_to :import

  enum error_type: {
    invalid_phone_number: 0, phone_number_blank: 1
  }

  def humanized_type
    error_type
  end
end
