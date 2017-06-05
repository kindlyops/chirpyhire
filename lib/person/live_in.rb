class Person::LiveIn < Person::Attribute
  def label
    'Live-In'
  end

  def label
    return 'Unknown' if candidacy.live_in.nil?
    return 'Live-In' if candidacy.live_in.present?

    'No Live-In'
  end

  def to_s
    candidacy.live_in.present?.to_s
  end

  def stat
    ' · Live-In' if candidacy.live_in
  end

  def query
    'live_in' if candidacy.live_in.present?
  end

  def tooltip_label
    'looking for live-in shifts' if candidacy.live_in.present?
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.live_in.nil?
    return 'fa-home' if candidacy.live_in.present?

    'fa-times-circle'
  end
end
