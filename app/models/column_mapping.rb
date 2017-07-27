class ColumnMapping < ApplicationRecord
  belongs_to :import

  def required?
    !optional?
  end
end
