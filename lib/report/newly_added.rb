class Report::NewlyAdded < Report::Base
  def subject_suffix
    "new #{icon}"
  end

  def icon
    '✨'
  end

  def icon_keyword
    ':sparkles:'
  end

  def count
    contacts.newly_added.count
  end
end
