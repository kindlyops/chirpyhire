require "administrate/base_dashboard"

class SurveyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    organization: Field::BelongsTo,
    template: Field::BelongsTo,
    actionable: Field::BelongsTo.with_options(class_name: "SurveyActionable"),
    questions: Field::HasMany,
    id: Field::Number,
    actionable_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :organization,
    :template,
    :actionable,
    :questions,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :organization,
    :template,
    :actionable,
    :questions,
    :id,
    :actionable_id,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :organization,
    :template,
    :actionable,
    :questions,
    :actionable_id,
  ].freeze

  # Overwrite this method to customize how surveys are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(survey)
  #   "Survey ##{survey.id}"
  # end
end
