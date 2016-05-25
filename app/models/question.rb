class Question < ActiveRecord::Base
  has_many :rules, as: :action
  belongs_to :template
  has_many :inquiries
  belongs_to :trigger

  validates :format, inclusion: { in: %w(text image) }

  delegate :organization, to: :template
  delegate :name, to: :template, prefix: true

  def image?
    format == "image"
  end

  def text?
    format == "text"
  end

  def perform(user)
    return if user.outstanding_inquiry.present?

    message = user.receive_message(body: template.render(user))
    inquiries.create(message: message)
  end
end
