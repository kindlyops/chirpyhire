class Search < ActiveRecord::Base
  belongs_to :account
  has_many :search_questions
  has_many :search_leads
  has_many :leads, through: :search_leads
  has_many :questions, through: :search_questions

  delegate :organization, to: :account

  accepts_nested_attributes_for :leads, :search_questions
  before_create :ensure_label

  def start
    search_leads.each do |search_lead|
      InquisitorJob.perform_later(search_lead, first_search_question)
    end
  end

  def first_search_question
    search_questions.find_by(previous_question: nil)
  end

  def search_question_after(search_question)
    search_questions.find_by(question: search_question.next_question)
  end

  private

  def ensure_label
    return if self.label.present?

    self.label = "#{account.name} search at #{DateTime.current}"
  end
end
