class InvoiceItem
  def initialize(item)
    @item = item
  end

  def description
    item['description']
  end

  def plan_name
    plan['name']
  end

  def plan
    item['plan'] || {}
  end

  def amount
    item['amount'].fdiv(100).round(2)
  end

  attr_reader :item
end
