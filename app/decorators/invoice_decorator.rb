class InvoiceDecorator < Draper::Decorator
  delegate_all

  def date
    Time.at(object.date).strftime('%b %d, %Y')
  end

  def icon
    return 'fa-check' if paid?
    return 'fa-gift' if forgiven?
    return 'fa-times-circle-o' if closed?
    return 'fa-spin fa-circle-o-notch' if attempted?
  end

  def status
    return 'Paid' if paid?
    return 'Forgiven' if forgiven?
    return 'Closed' if closed?
    return 'Attempted' if attempted?
  end

  def total
    "$#{object.total.fdiv(100).round(2)}"
  end
end
