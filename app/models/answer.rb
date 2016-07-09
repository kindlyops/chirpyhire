class Answer < ApplicationRecord
  include PublicActivity::Model
  include Messageable
  tracked owner: :user, only: :create
  has_many :activities, as: :trackable
  belongs_to :inquiry
  delegate :question_name, to: :inquiry
  validate :expected_format

  def expected_format
    unless inquiry.format == format
      errors.add(:inquiry, "expected #{inquiry.format} but received #{format}")
    end
  end

  def format
    return "document" if message.has_images?
    return "address" if message.has_address?
    return "choice" if message.has_choice?
    "text"
  end
end
