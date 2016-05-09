class Question < ActiveRecord::Base
  belongs_to :template
  has_many :inquiries
  has_many :actions, as: :actionable
  enum response: [:text, :image]
end
