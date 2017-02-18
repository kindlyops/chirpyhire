class Answer < ApplicationRecord
  belongs_to :message
  belongs_to :candidacy
end
