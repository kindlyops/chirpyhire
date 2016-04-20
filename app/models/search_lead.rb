class SearchLead < ActiveRecord::Base
  belongs_to :search
  belongs_to :lead

  delegate :organization, to: :lead
  delegate :first_search_question, to: :search

  enum status: [:pending, :processing, :finished]
  enum fit: [:possible_fit, :bad_fit, :good_fit]
end
