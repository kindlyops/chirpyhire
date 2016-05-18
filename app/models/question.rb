class Question < ActiveRecord::Base
  belongs_to :template
  has_many :inquiries
  has_many :actions, as: :actionable
  has_one :trigger, as: :observable

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
    inquiries.create(user: user, message_sid: message.sid)
  end
end
