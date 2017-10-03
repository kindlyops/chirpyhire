class Engage::Auto::QuestionsController < ApplicationController
  def new
    @question = bot.questions.build
    @question.follow_ups.build
  end

  def create
    prepare_tags
    @question = new_question

    if @question.save
      create_action
      redirect_to engage_auto_bot_path(bot), notice: 'Question created!'
    else
      render :new
    end
  end

  def destroy
    @question = authorize(bot.questions.find(params[:id]))
    destroy_question
    redirect_to engage_auto_bot_path(bot), notice: 'Question removed!'
  end

  private

  def destroy_question
    Question.transaction do
      migrate_action_follow_ups if params[:bot_action_id].present?
      @question.destroy
      rerank_questions
    end
  end

  def rerank_questions
    bot.reload.ranked_questions.each_with_index do |question, i|
      question.update(rank: i + 1)
    end
  end

  def migrate_action_follow_ups
    @question.action_follow_ups.find_each do |follow_up|
      follow_up.update(action: new_action)
    end
  end

  def new_action
    @new_action ||= authorize(bot.actions.find(params[:bot_action_id]), :show?)
  end

  def create_action
    bot.actions.create(type: 'QuestionAction', question_id: @question.id)
  end

  def prepare_tags
    follow_ups.each(&method(:prepare_follow_up))
  end

  def prepare_tag(i, name)
    tag = fetch_tag(name)
    taggings(i) << if tag.present?
                     { tag_id: tag.id }
                   else
                     { tag_attributes: tag_hash(name) }
                   end
  end

  def tag_hash(name)
    { name: name, organization_id: current_organization.id }
  end

  def prepare_follow_up(i, follow_up)
    initialize_taggings(i)

    tags = follow_up[:tags] || []
    tags.each { |tag| prepare_tag(i, tag) }
  end

  def fetch_tag(name)
    current_organization.tags.find_by(name: name)
  end

  def initialize_taggings(i)
    follow_ups[i][:taggings_attributes] = []
  end

  def taggings(i)
    follow_ups[i][:taggings_attributes]
  end

  def follow_ups
    params[:question][:follow_ups_attributes] || {}
  end

  def new_question
    authorize(bot.questions.build(permitted_attributes(Question)))
  end

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
