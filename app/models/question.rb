class Question < ApplicationRecord
  belongs_to :bot
  has_many :campaign_contacts
  has_many :follow_ups

  def trigger(_message, campaign_contact)
    campaign_contact.update(question: self)
    self
  end

  def follow_up(message, campaign_contact)
    Bot::QuestionFollowUp.call(self, message, campaign_contact)
  end
end
