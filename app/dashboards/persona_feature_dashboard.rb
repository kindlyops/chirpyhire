require "administrate/base_dashboard"

class PersonaFeatureDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    candidate_persona: Field::BelongsTo,
    candidate_features: Field::HasMany,
    id: Field::Number,
    format: Field::String,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    properties: Field::String.with_options(searchable: false),
    deleted_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :candidate_persona,
    :candidate_features,
    :id,
    :format,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :candidate_persona,
    :candidate_features,
    :id,
    :format,
    :name,
    :created_at,
    :updated_at,
    :properties,
    :deleted_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :candidate_persona,
    :candidate_features,
    :format,
    :name,
    :properties,
    :deleted_at,
  ].freeze

  # Overwrite this method to customize how persona features are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(persona_feature)
  #   "PersonaFeature ##{persona_feature.id}"
  # end
end
