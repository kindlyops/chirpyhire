class Note < ApplicationRecord
  acts_as_paranoid

  belongs_to :account
  belongs_to :contact
  delegate :handle, to: :account, prefix: true

  def self.by_recency
    order(:created_at, :id)
  end

  def self.days
    by_recency.chunk(&:day).map { |day| Note::Day.new(day) }
  end

  def day
    created_at.to_date
  end

  def tooltip_title
    Note::UpdatedAt.new(self).title
  end

  def timestamp_label
    Note::UpdatedAt.new(self).label
  end
end
