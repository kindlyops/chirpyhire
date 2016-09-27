class BackPopulate::ActivityBackPopulator
  def self.populate(candidate)
    activities = candidate.activities
    activities.each do |activity|
      update_activity(activity, candidate.organization)
    end
  end

  def self.update_activity(activity, organization)
    return if activity.properties.key?('stage_id')

    status_stage_map = {
      'Potential' => organization.potential_stage,
      'Bad Fit' => organization.bad_fit_stage,
      'Qualified' => organization.qualified_stage,
      'Hired' => organization.hired_stage,
    }

    status = activity.properties['status']
    if status.present?
      activity.properties['stage_id'] = status_stage_map[status].id
      activity.save!
    end
  end

  private_class_method :update_activity
end
