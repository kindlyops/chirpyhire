class ZipcodeQuestionsController < QuestionsController
  private

  def permitted_question_attributes
    super.merge(updated_at: Time.current)
  end
end
