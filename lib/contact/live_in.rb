class Contact::LiveIn < Contact::Attribute
  def label
    'Live-In'
  end

  def to_s
    candidacy.live_in.present?.to_s
  end

  def stat
    ' · Live-In' if candidacy.live_in
  end

  def humanize_attribute(*)
    label
  end

  def icon_class
    return 'fa-question' if candidacy.live_in.nil?

    'fa-home'
  end
end
