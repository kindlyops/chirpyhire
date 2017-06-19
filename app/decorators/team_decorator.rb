class TeamDecorator < Draper::Decorator
  delegate_all

  include HeroPatternable

  def url
    object.avatar && object.avatar.url(:medium)
  end
end
