class Question < ActiveRecord::Base
  belongs_to :template
  enum response: [:text, :image]
end
