class SearchPresenter
  delegate :account, :errors, to: :search
  attr_reader :search, :questions

  def initialize(search, questions)
    @search = search
    @questions = questions
  end

  def questions_grouped_by_category
    @questions_grouped_by_category ||= questions.group_by(&:category)
  end

  def question_categories
    questions_grouped_by_category.keys
  end
end
