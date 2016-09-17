# frozen_string_literal: true
require 'administrate/base_dashboard'

class PaperTrail::VersionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    item: Field::Polymorphic,
    version_associations: Field::HasMany,
    id: Field::Number,
    event: Field::String,
    whodunnit: Field::String,
    object: Field::String.with_options(searchable: false),
    transaction_id: Field::Number,
    created_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :item,
    :version_associations,
    :id,
    :event
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :item,
    :version_associations,
    :id,
    :event,
    :whodunnit,
    :object,
    :transaction_id,
    :created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :item,
    :version_associations,
    :event,
    :whodunnit,
    :object,
    :transaction_id
  ].freeze

  # Overwrite this method to customize how versions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(version)
  #   "PaperTrail::Version ##{version.id}"
  # end
end
