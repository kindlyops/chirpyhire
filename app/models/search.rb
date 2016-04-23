class Search < ActiveRecord::Base
  belongs_to :account
  has_many :search_questions
  has_many :search_leads
  has_many :leads, through: :search_leads
  has_many :questions, through: :search_questions

  delegate :organization, to: :account
  delegate :name, to: :account, prefix: true

  accepts_nested_attributes_for :leads, :search_questions
  before_create :ensure_title

  def good_fits
    leads.merge(search_leads.good_fit)
  end

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

  def result
    return "Found caregiver" if good_fits.any?

    "In progress"
  end

  private

  def ensure_title
    return if self.title.present?

    self.title = "#{account.name}'s Search"
  end
end
