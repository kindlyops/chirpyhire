class Question < ActiveRecord::Base
  enum category: [:schedule, :experience, :location, :credentials]

  has_many :inquiries
end
