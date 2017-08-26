class Report::NewlyAdded < Report::Base
  def subject_suffix
    "new #{icon}"
  end

  def icon
    '✨'
  end

  def count
    contacts.newly_added.count
  end
end
