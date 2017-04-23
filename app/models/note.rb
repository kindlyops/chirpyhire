class Note < ApplicationRecord
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
    Note::CreatedAt.new(self).title
  end

  def timestamp_label
    Note::CreatedAt.new(self).label
  end
end
