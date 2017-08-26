class Report::None < Report::Base
  def subject
    "#{organization.name}: No candidates yet #{icon}"
  end

  def icon
    '🏃'
  end

  def count
    0
  end
end
