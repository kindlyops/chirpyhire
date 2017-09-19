class Invoice < ApplicationRecord
  belongs_to :subscription, optional: true,
                            foreign_key: :subscription, primary_key: :stripe_id
  belongs_to :organization, foreign_key: :customer, primary_key: :stripe_id

  def lines
    (self[:lines]['data'] || []).map { |item| InvoiceItem.new(item) }
  end
end
