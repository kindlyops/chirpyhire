class Activity < PublicActivity::Activity
  delegate :organization, to: :owner

  def self.outstanding
    where(outstanding: true)
  end

  def has_chirp?
    trackable_type == "Chirp"
  end
end
