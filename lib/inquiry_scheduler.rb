class InquiryScheduler

  def initialize(job_candidate, job_question)
    @job_question = job_question
    @job_candidate = job_candidate
  end

  def call
    return inquire unless starting_search?

    ensure_sane_hours { inquire }
  end

  private

  attr_reader :job_candidate, :job_question

  def inquire
    Inquisitor.new(job_candidate, job_question).call
  end

  def starting_search?
    job_question.present? && job_question.starting_search?
  end

  def organization
    job_candidate.organization
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
    InquisitorJob.set(wait_until: at).perform_later(job_candidate, job_question)
  end
end
