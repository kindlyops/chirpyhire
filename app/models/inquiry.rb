class Inquiry < ActiveRecord::Base
  belongs_to :message
  belongs_to :question
  belongs_to :candidate

  delegate :phone_number, to: :candidate, prefix: true

  def body(prelude: false)
    template = ""
    template << "#{prelude_message} " if prelude
    template << question.body
    template << " #{preamble}"
  end

  private

  def prelude_message
    "Hey #{candidate.first_name}, this is #{candidate.owner_first_name} \
and #{candidate.organization_name}. We have a new client and want to see if you \
might be a good fit."
  end

  def preamble
    "Reply Y or N."
  end
end
