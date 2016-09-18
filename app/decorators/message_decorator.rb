class MessageDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  delegate :phone_number, :handle, to: :user, prefix: true

  def contents
    return 'images' if images.present?
    'text'
  end
end
