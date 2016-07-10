require "administrate/base_dashboard"

class ActivityDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    trackable: Field::Polymorphic,
    owner: Field::Polymorphic,
    recipient: Field::Polymorphic,
    id: Field::Number,
    key: Field::String,
    parameters: Field::Text,
    outstanding: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :trackable,
    :owner,
    :recipient,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :trackable,
    :owner,
    :recipient,
    :id,
    :key,
    :parameters,
    :outstanding,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :trackable,
    :owner,
    :recipient,
    :key,
    :parameters,
    :outstanding,
  ].freeze

  # Overwrite this method to customize how activities are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(activity)
  #   "Activity ##{activity.id}"
  # end
end
