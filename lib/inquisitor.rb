class Inquisitor

  def initialize(search_lead, search_question)
    @search_lead = search_lead
    @search_question = search_question
  end

  def call
    if existing_search_in_progress?
      search_lead.pending!
    elsif search_finished? || recently_answered_any_question_negatively?
      finish_search
    elsif recently_answered_positively?
      ask_next_question
    else
      search_lead.processing!
      ask_question
    end
  end

  private

  def organization
    search_lead.organization
  end

  def starting_search?
    search_question.present? && search_question.starting_search?
  end

  attr_reader :search_question, :search_lead

  def ask_question
    message = organization.ask(lead, question, prelude: starting_search?)
    inquiries.create(question: question, message: message)
  end

  def existing_search_in_progress?
    lead.has_other_search_in_progress?(search)
  end

  def search
    search_lead.search
  end

  def search_finished?
    search_question.blank?
  end

  def pending_searches?
    lead.has_pending_searches?
  end

  def start_pending_search
    InquisitorJob.perform_later(
      next_search_lead,
      next_search_lead.first_search_question
    )
  end

  def next_search_lead
    @next_search_lead ||= lead.oldest_pending_search_lead
  end

  def ask_next_question
    InquisitorJob.perform_later(search_lead, search.search_question_after(search_question))
  end

  def recently_answered_any_question_negatively?
    lead.recently_answered_negatively?(questions)
  end

  def recently_answered_positively?
    lead.recently_answered_positively?(question)
  end

  def finish_search
    search_lead.determine_fit
    search_lead.finished!
    start_pending_search if pending_searches?
  end

  def lead
    @lead ||= search_lead.lead
  end

  def question
    @question ||= search_question.question
  end

  def questions
    search_lead.search.questions
  end

  def inquiries
    lead.inquiries
  end
end
