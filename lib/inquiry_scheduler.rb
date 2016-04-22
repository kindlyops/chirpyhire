class InquiryScheduler

  def initialize(search_lead, search_question)
    @search_question = search_question
    @search_lead = search_lead
  end

  def call
    return inquire unless starting_search?

    ensure_sane_hours { inquire }
  end

  private

  attr_reader :search_lead, :search_question

  def inquire
    Inquisitor.new(search_lead, search_question).call
  end

  def starting_search?
    search_question.present? && search_question.starting_search?
  end

  def organization
    search_lead.organization
  end

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
