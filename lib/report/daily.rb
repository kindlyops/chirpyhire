class Report::Daily

  def initialize(recipient, date: Date.current)
    @recipient = recipient
    @date = date
  end

  delegate :name, to: :organization, prefix: true
  delegate :first_name, to: :recipient, prefix: true

  def humanized_date
    date.strftime("%B #{date.day.ordinalize}")
  end

  def screened_candidate_count
    organization.candidates.screened.where(created_at: date.beginning_of_day..date.end_of_day).count
  end

  private

  def organization
    @organization ||= recipient.organization
  end

  attr_reader :recipient, :date
end
