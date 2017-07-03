class Question < ApplicationRecord
  belongs_to :bot
  has_many :campaign_contacts
  has_many :follow_ups
  validates :rank, presence: true

  def trigger(_message, campaign_contact)
    campaign_contact.update(question: self)
    body
  end

  def follow_up(message, campaign_contact)
    Bot::QuestionFollowUp.call(self, message, campaign_contact)
  end

  def last_follow_up
    follow_ups.order(:rank).last
  end

  def next_follow_up_rank
    return 1 if last_follow_up.blank?

    last_follow_up.rank + 1
  end
end
