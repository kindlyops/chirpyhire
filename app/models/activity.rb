class Activity < PublicActivity::Activity
  delegate :organization, to: :owner

  def self.outstanding
    where(outstanding: true)
  end
end
