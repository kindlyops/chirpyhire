class QuestionOrderer
  def initialize(survey)
    @survey = survey
  end

  def reorder(questions_with_order)
    Organization.transaction do
      clear_question_priorities_for_update
      update_questions_to_new_values(questions_with_order)
    end
  end

  private

  attr_reader :survey

  def clear_question_priorities_for_update
    # To avoid Unique Key errors, set all values to
    # their negative before updating
    survey.questions.each do |question|
      question.update!(priority: question.priority * -1)
    end
  end

  def update_questions_to_new_values(questions_with_order)
    survey.questions.each do |question|
      new_priority = questions_with_order[question.id.to_s][:priority].to_i
      question.update!(priority: new_priority)
    end
  end
end
