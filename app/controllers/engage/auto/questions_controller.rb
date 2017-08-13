class Engage::Auto::QuestionsController < ApplicationController
  def new
    @question = bot.questions.build
  end

  def create
    prepare_tags
    @question = new_question

    if @question.save
      follow_ups.each do |param|
      end

      redirect_to engage_auto_bot_path(bot), notice: 'Question created!'
    else
      render :new
    end
  end

  private

  def prepare_tags
    follow_ups.each(&method(:prepare_follow_up))
  end

  def prepare_tag(name)
    tag = fetch_tag(name)
    taggings(i) << if tag.present?
                     { tag_id: tag.id }
                   else
                     { tag_attributes: tag_hash(name) }
                   end
  end

  def tag_hash(name)
    { name: name, organization: current_organization }
  end

  def prepare_follow_up(i, follow_up)
    initialize_taggings(i)

    follow_up.tags.each(&method(:prepare_tag))
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
    params[:question][:follow_ups_attributes]
  end

  def new_question
    authorize(bot.questions.build(permitted_attributes(Question)))
  end

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
