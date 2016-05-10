class Answer < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :message

  validate :expected_format

  def expected_format
    unless inquiry.expects?(message)
      errors.add(:inquiry, "expected #{inquiry.question.format}")
    end
  end
end
