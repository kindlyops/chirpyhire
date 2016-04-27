class JobsController < ApplicationController
  before_action :ensure_subscribed_candidates, only: :create
  before_action :ensure_questions, only: :create

  def show
    @job = jobs.find(params[:id])
  end

  def index
    @jobs = jobs
  end

  def create
    if job.save
      job.start
      redirect_to job, notice: "Finding a caregiver now. Come back and check this page in a little while to see caregivers that would be a good fit."
    else
      render :new
    end
  end

  def new
    @job = JobPresenter.new(current_account.jobs.build, questions)
  end

  private

  def job
    @job ||= current_account.jobs.build(job_questions: job_questions, candidates: subscribed_candidates)
  end

  def jobs
    organization.jobs
  end

  def job_questions
    question_ids.map.with_index(&method(:build_job_questions))
  end

  def build_job_questions(id, index)
    JobQuestion.new(
      question_id: id,
      next_question_id: get_array_value(index+1),
      previous_question_id: get_array_value(index-1)
    )
  end

  def get_array_value(index)
    return if index < 0
    question_ids[index]
  end

  def questions
    organization.questions
  end

  def question_ids
    @question_ids ||= job_attributes[:question_ids]
  end

  def job_attributes
    @job_attributes ||= params[:job] || {}
  end

  def ensure_subscribed_candidates
    if subscribed_candidates.blank?
      redirect_to :back, alert: "There are no subscribed candidates!"
    end
  end

  def ensure_questions
    if question_ids.blank?
      redirect_to :back, alert: "No questions selected!"
    end
  end
end
