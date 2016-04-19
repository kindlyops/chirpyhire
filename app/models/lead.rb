class Lead < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :referrals
  has_many :inquiries
  has_many :answers

  delegate :first_name, :phone_number, to: :user

  def ask(question)
    message = organization.ask(self, question)
    inquiries.create(question: question, message: message)
  end

  def recently_answered?(question)
    answers.recent.where(question: question).exists?
  end
end
