class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :lead
  belongs_to :message
end
