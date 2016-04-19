class Question < ActiveRecord::Base
  enum category: [:schedule, :experience, :location, :credentials]
end
