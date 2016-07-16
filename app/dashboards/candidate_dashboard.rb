require "administrate/base_dashboard"

class CandidateDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    candidate_persona: Field::BelongsTo,
    candidate_features: Field::HasMany,
    referrals: Field::HasMany,
    referrers: Field::HasMany,
    id: Field::Number,
    status: Field::String,
    screened: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :candidate_persona,
    :candidate_features,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :candidate_persona,
    :candidate_features,
    :referrals,
    :referrers,
    :id,
    :status,
    :screened,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :candidate_persona,
    :candidate_features,
    :referrals,
    :referrers,
    :status,
    :screened,
  ].freeze

  # Overwrite this method to customize how candidates are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(candidate)
  #   "Candidate ##{candidate.id}"
  # end
end
