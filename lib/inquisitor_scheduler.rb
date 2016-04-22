class InquisitorScheduler

  def initialize(inquisitor)
    @inquisitor = inquisitor
  end

  def call
    if starting_search?
      ensure_sane_hours { yield }
    else
      yield
    end
  end

  private

  attr_reader :inquisitor

  delegate :organization, :search_lead, :search_question, :starting_search?, to: :inquisitor

  def ensure_sane_hours
    Time.use_zone(organization.time_zone) do
      if Time.current.between?(ten_am, eight_pm)
        yield
      elsif Time.current < ten_am
        try_later(at: ten_am + 1.minute)
      elsif Time.current > eight_pm
        try_later(at: ten_am.tomorrow + 1.minute)
      end
    end
  end

  def ten_am
    Time.current.at_beginning_of_day.advance(hours: 10)
  end

  def eight_pm
    Time.current.at_beginning_of_day.advance(hours: 20)
  end

  def try_later(at:)
    InquisitorJob.set(wait_until: at).perform_later(search_lead, search_question)
  end
end
