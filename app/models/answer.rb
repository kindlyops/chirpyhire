class Answer < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :message
  delegate :organization, :has_images?, to: :message

  validate :expected_format
  accepts_nested_attributes_for :message

  def expected_format
    unless inquiry.expects?(self)
      errors.add(:inquiry, "expected #{inquiry.feature_format}")
    end
  end

  def body
    message.body
  end

  def format
    return :image if has_images?
    :text
  end
end
