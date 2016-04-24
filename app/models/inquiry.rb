class Inquiry < ActiveRecord::Base
  belongs_to :message
  belongs_to :question
  belongs_to :lead

  delegate :phone_number, to: :lead, prefix: true

  def body(prelude: false)
    template = ""
    template << "#{prelude_message} " if prelude
    template << question.body
    template << " #{preamble}"
  end

  private

  def prelude_message
    "Hey #{lead.first_name}, this is #{lead.owner_first_name} \
and #{lead.organization_name}. We have a new client and want to see if you \
might be a good fit."
  end

  def preamble
    "Reply Y or N."
  end
end
