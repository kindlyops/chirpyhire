class Activity < PublicActivity::Activity
  def self.qualified
    where("properties->>'status' = ?", "Qualified")
  end

  def self.hired
    where("properties->>'status' = ?", "Hired")
  end

  def self.bad_fit
    where("properties->>'status' = ?", "Bad Fit")
  end

  def self.potential
    where("properties->>'status' = ?", "Potential")
  end
end
