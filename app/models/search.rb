class Search < ActiveRecord::Base
  belongs_to :organization
  has_many :search_questions
  has_many :search_leads

  def self.next_question_for(lead)
    join(:search_leads).where(search_leads: { lead: lead })
  end
end
