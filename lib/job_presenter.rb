class JobPresenter
  delegate :account, :errors, to: :job
  attr_reader :job, :questions

  def initialize(job, questions)
    @job = job
    @questions = questions
  end

  def questions_grouped_by_category
    @questions_grouped_by_category ||= questions.group_by(&:category)
  end

  def question_categories
    questions_grouped_by_category.keys
  end
end
