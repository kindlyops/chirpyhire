class Question < ActiveRecord::Base
  has_many :inquiries
  has_many :answers
  belongs_to :question_category

  delegate :name, to: :question_category, prefix: true

  def readonly?
    !new_record? && !custom?
  end
end
