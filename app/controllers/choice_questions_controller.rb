class ChoiceQuestionsController < QuestionsController
  private

  def permitted_question_attributes
    super.merge(updated_at: Time.current)
  end
  
  def built_question_params
    super.merge(choice_question_options_attributes: [
                  { letter: 'a' }, { letter: 'b' }
                ])
  end
end
