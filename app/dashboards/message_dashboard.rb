require "administrate/base_dashboard"

class MessageDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    activities: Field::HasMany,
    media_instances: Field::HasMany,
    user: Field::BelongsTo,
    chirp: Field::HasOne,
    inquiry: Field::HasOne,
    answer: Field::HasOne,
    notification: Field::HasOne,
    id: Field::Number,
    sid: Field::String,
    body: Field::Text,
    direction: Field::String,
    messageable_id: Field::Number,
    messageable_type: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :activities,
    :media_instances,
    :user,
    :chirp,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :activities,
    :media_instances,
    :user,
    :chirp,
    :inquiry,
    :answer,
    :notification,
    :id,
    :sid,
    :body,
    :direction,
    :messageable_id,
    :messageable_type,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :activities,
    :media_instances,
    :user,
    :chirp,
    :inquiry,
    :answer,
    :notification,
    :sid,
    :body,
    :direction,
    :messageable_id,
    :messageable_type,
  ].freeze

  # Overwrite this method to customize how messages are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(message)
  #   "Message ##{message.id}"
  # end
end
