class Report::SlippingAway < Report::Base
  def subject_suffix
    "slipping away #{icon}"
  end

  def icon
    '🎣'
  end

  def count
    contacts.slipping_away.count
  end
end
