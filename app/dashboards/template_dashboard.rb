require 'administrate/base_dashboard'

class TemplateDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    organization: Field::BelongsTo,
    notifications: Field::HasMany,
    actionable: Field::BelongsTo.with_options(class_name: 'TemplateActionable'),
    id: Field::Number,
    name: Field::String,
    body: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    actionable_id: Field::Number
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :organization,
    :notifications,
    :actionable,
    :id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :organization,
    :notifications,
    :actionable,
    :id,
    :name,
    :body,
    :created_at,
    :updated_at,
    :actionable_id
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :organization,
    :notifications,
    :actionable,
    :name,
    :body,
    :actionable_id
  ].freeze

  # Overwrite this method to customize how templates are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(template)
  #   "Template ##{template.id}"
  # end
end
