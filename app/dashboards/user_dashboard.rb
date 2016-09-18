require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    organization: Field::BelongsTo,
    candidate: Field::HasOne,
    referrer: Field::HasOne,
    account: Field::HasOne,
    messages: Field::HasMany,
    inquiries: Field::HasMany,
    answers: Field::HasMany,
    notifications: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    phone_number: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    subscribed: Field::Boolean,
    has_unread_messages: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :organization,
    :candidate,
    :referrer,
    :account,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :organization,
    :candidate,
    :referrer,
    :account,
    :messages,
    :inquiries,
    :answers,
    :notifications,
    :id,
    :first_name,
    :last_name,
    :phone_number,
    :created_at,
    :updated_at,
    :subscribed,
    :has_unread_messages,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :organization,
    :candidate,
    :referrer,
    :account,
    :messages,
    :inquiries,
    :answers,
    :notifications,
    :first_name,
    :last_name,
    :phone_number,
    :subscribed,
    :has_unread_messages,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
