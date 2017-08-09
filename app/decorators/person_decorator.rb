class PersonDecorator < Draper::Decorator
  delegate_all
  decorates_association :account
  decorates_association :bot
  decorates_association :contact

  def hero_pattern_classes
    account.hero_pattern_classes if object.account.present?
    contact.hero_pattern_classes if object.contact.present?
    bot.hero_pattern_classes if object.bot.present?
  end
end
