class Search < ActiveRecord::Base
  belongs_to :account
  has_many :search_questions
  has_many :search_candidates
  has_many :candidates, through: :search_candidates
  has_many :questions, through: :search_questions

  delegate :organization, to: :account
  delegate :name, to: :account, prefix: true

  accepts_nested_attributes_for :candidates, :search_questions
  before_create :ensure_title

  def good_fits
    candidates.merge(search_candidates.good_fit)
  end

  def start
    search_candidates.each do |search_candidate|
      InquisitorJob.perform_later(search_candidate, first_search_question)
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
