class Invoice < ApplicationRecord
  belongs_to :subscription
  delegate :organization, to: :subscription

  def lines
    (self[:lines]['data'] || []).map { |item| InvoiceItem.new(item) }
  end
end
