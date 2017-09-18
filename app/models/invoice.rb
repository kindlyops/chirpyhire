class Invoice < ApplicationRecord
  belongs_to :subscription
  has_one :charge
  delegate :organization, to: :subscription

  def lines
    (self[:lines]["data"] || []).map { |item| InvoiceItem.new(item) }
  end
end
