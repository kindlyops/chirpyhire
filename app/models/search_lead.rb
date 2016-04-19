class SearchLead < ActiveRecord::Base
  belongs_to :search
  belongs_to :lead

  has_many :search_question_messages
end
