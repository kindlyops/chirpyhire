class Report::Passive < Report::Base
  def subject_suffix
    "passive #{icon}"
  end

  def icon
    '👋'
  end

  def icon_keyword
    ':wave:'
  end

  def count
    contacts.passive.count
  end
end
