class Report::Active < Report::Base
  def subject_suffix
    "active #{icon}"
  end

  def icon
    '👏'
  end

  def count
    contacts.active.count
  end
end
