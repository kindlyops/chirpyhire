class Candidacy < ApplicationRecord
  belongs_to :person

  has_many :inquiries
  has_many :answers

  def outstanding_inquiry
    inquiries.unanswered.first
  end
end
