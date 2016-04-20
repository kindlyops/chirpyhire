class SearchQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :next_question, class_name: "Question"
  belongs_to :search

  def unanswered_questions_in(searches)
    search_questions.where(search: searches).unanswered
  end
end
