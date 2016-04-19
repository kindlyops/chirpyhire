class Search < ActiveRecord::Base
  belongs_to :organization
  has_many :search_questions
end
