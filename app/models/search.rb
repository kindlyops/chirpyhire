class Search < ActiveRecord::Base
  belongs_to :account
  has_many :search_questions
  has_many :search_leads
  has_many :leads, through: :search_leads
  has_many :questions, through: :search_questions

  before_create :ensure_label

  def ensure_label
    return if self.label.present?

    self.label = "#{account.name} search at #{DateTime.current}"
  end

  def make_inquiries
    leads.each { |lead| InquisitorJob.perform_later(lead, first_question) }
  end

  def first_question
    search_questions.find_by(previous_question: nil)
  end
end
