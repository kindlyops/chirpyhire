# frozen_string_literal: true
class OrganizationDecorator < Draper::Decorator
  delegate_all

  def phone_number
    (object.phone_number || '').phony_formatted
  end
end
