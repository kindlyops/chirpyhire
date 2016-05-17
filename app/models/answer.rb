class Answer < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :user
  delegate :organization, to: :user

  validate :expected_format

  def expected_format
    unless inquiry.expects?(self)
      errors.add(:inquiry, "expected #{inquiry.question.format}")
    end
  end

  def body
    message.body
  end

  def has_images?
    message.media.any?(&:image?)
  end

  def format
    return :image if has_images?
    :text
  end

  private

  def message
    @message ||= organization.messages.get(message_sid)
  end
end
