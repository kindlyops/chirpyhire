class ContactStage < ApplicationRecord
  belongs_to :organization

  has_many :contacts
  before_validation :ensure_rank

  def self.ranked
    order(:rank)
  end

  private

  def ensure_rank
    return if rank.present?
    self.rank = organization.next_contact_stage_rank
  end
end
