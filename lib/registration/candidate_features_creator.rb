class Registration::CandidateFeaturesCreator
  def initialize(user)
    @user = user
  end

  def call
    candidate = user.create_candidate(stage: user.organization.qualified_stage)
    create_address_feature(candidate)
    create_availability_feature(candidate)
    create_transportation_feature(candidate)
  end

  private

  attr_reader :user
  delegate :organization, to: :user

  def create_address_feature(candidate)
    candidate.candidate_features.create(
      label: 'Address',
      properties: address_feature_properties
    )
  end

  def create_availability_feature(candidate)
    candidate.candidate_features.create(
      label: 'Availability',
      properties: {
        child_class: 'choice',
        choice_option: 'Hourly'
      }
    )
  end

  def create_transportation_feature(candidate)
    candidate.candidate_features.create(
      label: 'Transportation',
      properties: {
        child_class: 'yes_no',
        yes_no_option: 'Yes'
      }
    )
  end

  def address_feature_properties
    {
      child_class: 'address',
      address: location.full_street_address,
      latitude: location.latitude,
      longitude: location.longitude,
      postal_code: location.postal_code,
      country: location.country,
      city: location.city
    }
  end

  def location
    @location ||= organization.location
  end
end
