class ColumnMapping < ApplicationRecord
  belongs_to :import

  def required?
    !optional?
  end

  def valid_for_import?
    optional? || column_number.present?
  end

  def next_mapping
    import.mapping_after(self)
  end

  def previous_mapping
    import.mapping_before(self)
  end

  def load_error(import)
    return if valid_for_import?

    import.errors.add(mapping: invalid_import_error_message)
  end

  private

  def invalid_import_error_message
    "#{contact_attribute.humanize} is required and currently missing."
  end
end
