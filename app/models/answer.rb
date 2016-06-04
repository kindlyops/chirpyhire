class Answer < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :message
  delegate :organization, to: :message
  delegate :question_name, to: :inquiry

  validate :expected_format
  accepts_nested_attributes_for :message

  def expected_format
    unless inquiry.format == format
      errors.add(:inquiry, "expected #{inquiry.format} but received #{format}")
    end
  end

  def body
    message.body
  end

  def format
    return "document" if message.has_images?
    return "address" if message.has_address?
    "text"
  end
end
