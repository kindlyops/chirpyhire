class ImportError < ApplicationRecord
  belongs_to :import

  enum error_type: {
    invalid_phone_number: 0, blank_phone_number: 1, invalid_stage: 2
  }

  def humanized_type
    {
      invalid_phone_number: 'Phone number invalid.',
      blank_phone_number: 'Phone number is missing.',
      invalid_stage: 'Stage invalid.'
    }[error_type.to_sym]
  end
end
