class Search < ActiveRecord::Base
  belongs_to :organization
  has_many :search_questions
  has_many :search_leads
  has_many :leads, through: :search_leads
  has_many :questions, through: :search_questions

  def <<(lead)
    search_leads.create(lead: lead)
  end
end
