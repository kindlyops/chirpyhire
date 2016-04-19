class SearchQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :next_question, class_name: "Question"
  belongs_to :search

  has_many :search_question_messages
end
