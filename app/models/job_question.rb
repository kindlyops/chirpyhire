class JobQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :next_question, class_name: "Question"
  belongs_to :previous_question, class_name: "Question"
  belongs_to :job

  def starting_search?
    previous_question.blank?
  end
end
