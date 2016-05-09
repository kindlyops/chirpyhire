class Question < ActiveRecord::Base
  belongs_to :template
  has_many :inquiries
  enum response: [:text, :image]
end
