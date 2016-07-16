require "administrate/base_dashboard"

class MessageDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    media_instances: Field::HasMany,
    user: Field::BelongsTo,
    inquiry: Field::HasOne,
    answer: Field::HasOne,
    notification: Field::HasOne,
    id: Field::Number,
    sid: Field::String,
    body: Field::Text,
    direction: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    sent_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :media_instances,
    :user,
    :inquiry,
    :answer,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :media_instances,
    :user,
    :inquiry,
    :answer,
    :notification,
    :id,
    :sid,
    :body,
    :direction,
    :created_at,
    :updated_at,
    :sent_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :media_instances,
    :user,
    :inquiry,
    :answer,
    :notification,
    :sid,
    :body,
    :direction,
    :sent_at,
  ].freeze

  # Overwrite this method to customize how messages are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(message)
  #   "Message ##{message.id}"
  # end
end
