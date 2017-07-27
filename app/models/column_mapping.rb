class ColumnMapping < ApplicationRecord
  belongs_to :import

  def required?
    !optional?
  end

  def next_mapping
    import.mapping_after(self)
  end

  def previous_mapping
    import.mapping_before(self)
  end
end
