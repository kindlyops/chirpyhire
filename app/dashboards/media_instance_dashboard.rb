# frozen_string_literal: true
require 'administrate/base_dashboard'

class MediaInstanceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    message: Field::BelongsTo,
    id: Field::Number,
    sid: Field::String,
    content_type: Field::String,
    uri: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :message,
    :id,
    :sid,
    :content_type
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :message,
    :id,
    :sid,
    :content_type,
    :uri,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :message,
    :sid,
    :content_type,
    :uri
  ].freeze

  # Overwrite this method to customize how media instances are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(media_instance)
  #   "MediaInstance ##{media_instance.id}"
  # end
end
