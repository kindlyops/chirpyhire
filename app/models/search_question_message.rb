class SearchQuestionMessage < ActiveRecord::Base
  belongs_to :message
  belongs_to :search_question
  belongs_to :search_lead
end
