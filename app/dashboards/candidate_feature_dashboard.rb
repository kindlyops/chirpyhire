require "administrate/base_dashboard"

class CandidateFeatureDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    candidate: Field::BelongsTo,
    persona_feature: Field::BelongsTo,
    inquiries: Field::HasMany,
    id: Field::Number,
    properties: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :candidate,
    :persona_feature,
    :inquiries,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :candidate,
    :persona_feature,
    :inquiries,
    :id,
    :properties,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :candidate,
    :persona_feature,
    :inquiries,
    :properties,
  ].freeze

  # Overwrite this method to customize how candidate features are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(candidate_feature)
  #   "CandidateFeature ##{candidate_feature.id}"
  # end
end
