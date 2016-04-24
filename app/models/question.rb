class Question < ActiveRecord::Base
  enum category: [:schedule, :preferences, :experience, :location, :credentials, :transportation]

  has_many :inquiries
  has_many :answers

  def readonly?
    !new_record? && !custom?
  end
end
