class Activity < PublicActivity::Activity
  def self.outstanding
    where(outstanding: true)
  end
end
