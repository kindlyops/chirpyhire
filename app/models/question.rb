class Question < ActiveRecord::Base
  enum category: [:schedule, :preference, :experience, :location, :credentials, :transportation]

  has_many :inquiries
  has_many :answers
  belongs_to :organization

  def readonly?
    !new_record? && !custom?
  end
end
