class Question < ActiveRecord::Base
  enum category: [:schedule, :experience, :location, :credentials]

  def attempt_inquiry

  end
end
