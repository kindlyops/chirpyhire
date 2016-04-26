class Inquisitor

  def initialize(search_candidate, search_question)
    @search_candidate = search_candidate
    @search_question = search_question
  end

  def call
    if existing_search_in_progress?
      search_candidate.pending!
    elsif search_finished? || recently_answered_any_question_negatively?
      finish_search
    elsif recently_answered_positively?
      ask_next_question
    else
      search_candidate.processing!
      ask_question
    end
  end

  private

  def organization
    search_candidate.organization
  end

  def starting_search?
    search_question.present? && search_question.starting_search?
  end

  attr_reader :search_question, :search_candidate

  def ask_question
    organization.ask(inquiries.build(question: question), prelude: starting_search?)
  end

  def existing_search_in_progress?
    candidate.has_other_search_in_progress?(search)
  end

  def search
    search_candidate.search
  end

  def search_finished?
    search_question.blank?
  end

  def pending_searches?
    candidate.has_pending_searches?
  end

  def start_pending_search
    InquisitorJob.perform_later(
      next_search_candidate,
      next_search_candidate.first_search_question
    )
  end

  def next_search_candidate
    @next_search_candidate ||= candidate.oldest_pending_search_candidate
  end

  def ask_next_question
    InquisitorJob.perform_later(search_candidate, search.search_question_after(search_question))
  end

  def recently_answered_any_question_negatively?
    candidate.recently_answered_negatively?(questions)
  end

  def recently_answered_positively?
    candidate.recently_answered_positively?(question)
  end

  def finish_search
    search_candidate.determine_fit
    search_candidate.finished!
    start_pending_search if pending_searches?
  end

  def candidate
    @candidate ||= search_candidate.candidate
  end

  def question
    @question ||= search_question.question
  end

  def questions
    search_candidate.search.questions
  end

  def inquiries
    candidate.inquiries
  end
end
