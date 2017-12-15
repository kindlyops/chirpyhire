class ContactStage < ApplicationRecord
  belongs_to :organization
  has_many :contacts
  has_many :goals

  before_validation :ensure_rank

  def self.ranked
    order(:rank)
  end

  def self.potential
    where(name: 'Potential')
  end

  def self.screened
    where(name: 'Screened')
  end

  def self.scheduled
    where(name: 'Scheduled')
  end

  def self.not_now
    where(name: 'Not Now')
  end

  def self.hired
    where(name: 'Hired')
  end

  def self.archived
    where(name: 'Archived')
  end

  def last_stage?
    organization.contact_stages.last == self
  end

  private

  def ensure_rank
    return if rank.present?
    self.rank = organization.next_contact_stage_rank
  end
end
