class Engage::Auto::FollowUpsController < ApplicationController
  def edit
    @follow_up = authorize(bot.follow_ups.find(params[:id]))
  end

  def update
    @follow_up = authorize(bot.follow_ups.find(params[:id]))

    if @follow_up.update(permitted_attributes(@follow_up.type.constantize))
      update_tags_and_redirect
    else
      render :edit
    end
  end

  private

  def update_tags_and_redirect
    @follow_up.tags = updated_tags
    redirect_to engage_auto_bot_path(bot), notice: 'Follow up updated!'
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
