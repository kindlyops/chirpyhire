class NoteDecorator < Draper::Decorator
  delegate_all
  decorates_association :account

  def sender_hero_pattern_classes
    account.hero_pattern_classes
  end

  def sender_handle
    account.handle
  end

  def sender_id
    account.id
  end
end
