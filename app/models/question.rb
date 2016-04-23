class Question < ActiveRecord::Base
  enum category: [:schedule, :preferences, :experience, :location, :credentials, :transportation]

  has_many :inquiries
  has_many :answers
  belongs_to :organization

  def readonly?
    !new_record? && !custom?
  end

  def body_for(lead, prelude: false)
    template = ""
    template << "#{prelude_for(lead)} " if prelude
    template << body
    template << " #{preamble}"
  end

  private

  def preamble
    "Reply Y or N."
  end

  def prelude_for(lead)
    "Hey #{lead.first_name}, this is #{organization.owner_first_name} \
and #{organization.name}. We have a new client and want to see if you \
might be a good fit."
  end
end
