class BackPopulate::ActivityBackPopulator
  def self.populate(candidate)
    activities = candidate.activities
    organization = candidate.organization
    activities.each do |activity|
      update_activity(activity, organization)
    end
  end

  def self.update_activity(activity, organization)
    return if activity.properties.key?('stage_id')
    status = activity.properties['status']
    if status.present?
      activity.properties['stage_id'] =
        status_stage_map(organization)[status].id
      activity.save!
    end
  end

  def self.status_stage_map(organization)
    {
      'Potential' => organization.potential_stage,
      'Bad Fit' => organization.bad_fit_stage,
      'Qualified' => organization.qualified_stage,
      'Hired' => organization.hired_stage,
    }
  end

  private_class_method :update_activity
end
