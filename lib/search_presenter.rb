class SearchPresenter
  delegate :account, :errors, to: :search
  attr_reader :search, :questions

  def initialize(search: search, questions: questions)
    @search = search
    @questions = questions
  end

  def question_categories
    questions.group_by(&:category)
  end
end
