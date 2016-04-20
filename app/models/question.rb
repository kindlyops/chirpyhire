class Question < ActiveRecord::Base
  enum category: [:schedule, :experience, :location, :credentials]

  has_many :inquiries
  has_many :answers
  belongs_to :organization
end
