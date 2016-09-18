require "administrate/base_dashboard"

class DocumentQuestionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    survey: Field::BelongsTo,
    inquiries: Field::HasMany,
    id: Field::Number,
    text: Field::String,
    status: Field::String.with_options(searchable: false),
    priority: Field::Number,
    type: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    label: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :survey,
    :inquiries,
    :id,
    :text,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :survey,
    :inquiries,
    :id,
    :text,
    :status,
    :priority,
    :type,
    :created_at,
    :updated_at,
    :label,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :survey,
    :inquiries,
    :text,
    :status,
    :priority,
    :type,
    :label,
  ].freeze

  # Overwrite this method to customize how document questions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(document_question)
  #   "DocumentQuestion ##{document_question.id}"
  # end
end
