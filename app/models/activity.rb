class Activity < PublicActivity::Activity
  delegate :organization, to: :owner

  def self.outstanding
    where(outstanding: true)
  end

  def has_message?
    trackable_type == "Message" || trackable_type == "Chirp"
  end
end
