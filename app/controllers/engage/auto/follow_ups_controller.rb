class Engage::Auto::FollowUpsController < ApplicationController
  def new
    @follow_up = authorize(question.follow_ups.build)
  end

  def edit
    @follow_up = authorize(question.follow_ups.find(params[:id]))
  end

  def update
    @follow_up = authorize(question.follow_ups.find(params[:id]))

    if @follow_up.update(permitted_attributes(FollowUp))
      update_tags_and_redirect('Follow up updated!')
    else
      render :edit
    end
  end

  def create
    @follow_up = new_follow_up

    if @follow_up.save
      update_tags_and_redirect('Follow up created!')
    else
      render :new
    end
  end

  private

  def new_follow_up
    authorize(question.follow_ups.build(permitted_attributes(FollowUp)))
  end

  def question
    @question ||= authorize(bot.questions.find(params[:question_id]), :show?)
  end

  def update_tags_and_redirect(notice)
    @follow_up.tags = updated_tags
    redirect_to engage_auto_bot_path(bot), notice: notice
  end

  def updated_tags
    @updated_tags ||= begin
      params[:follow_up][:tags].map do |tag|
        current_organization.tags.find_or_create_by(name: tag)
      end
    end
  end

  def bot
    @bot ||= authorize(Bot.find(params[:bot_id]), :show?)
  end
end
