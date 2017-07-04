class BotsChannel < ApplicationCable::Channel
  def subscribed
    reject if bot.blank?
    stream_for bot
  end

  delegate :bots, to: :current_organization

  private

  def bot
    @bot ||= authorize(bots.find(params[:id]), :show?)
  end
end
