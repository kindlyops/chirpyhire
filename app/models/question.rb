class Question < ActiveRecord::Base
  enum category: [:schedule, :preferences, :experience, :location, :credentials, :transportation]

  has_many :inquiries
  has_many :answers
  belongs_to :industry

  def readonly?
    !new_record? && !custom?
  end

  def body_for(lead, prelude: false)
    template = ""
    template << "#{lead.prelude} " if prelude
    template << body
    template << " #{lead.preamble}"
  end
end
