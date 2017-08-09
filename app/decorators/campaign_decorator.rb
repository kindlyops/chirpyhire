class CampaignDecorator < Draper::Decorator
  delegate_all

  def status_icon
    'fa-play'
  end

  def created_at
    TimestampDecorator.new(object, :created_at)
  end
end
