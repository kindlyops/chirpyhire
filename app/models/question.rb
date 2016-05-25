class Question < ActiveRecord::Base
  belongs_to :template
  has_many :inquiries
  belongs_to :trigger
  belongs_to :action

  validates :format, inclusion: { in: %w(text image) }

  delegate :organization, to: :template
  delegate :name, to: :template, prefix: true

  def image?
    format == "image"
  end

  def text?
    format == "text"
  end

  def action
    super || create_action(organization: organization)
  end

  def perform(user)
    return if user.outstanding_inquiry.present?

    message = user.receive_message(body: template.render(user))
    inquiries.create(message: message)
  end
end
