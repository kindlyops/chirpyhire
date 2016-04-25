class QuestionTemplate < ActiveRecord::Base
  has_many :questions
  enum category: [:schedule, :credentials, :transportation, :experience, :preferences]
end
