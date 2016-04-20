class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :lead
  belongs_to :message

  scope :recent, -> { where('created_at > ?', 30.days.ago) }

  def self.positive
    where(body: "Y")
  end

  def self.negative
    where(body: "N")
  end

  def self.to(question)
    where(question: question)
  end
end
