class PersonDecorator < Draper::Decorator
  delegate_all
  decorates_association :account
  decorates_association :bot
  decorates_association :contact

  def hero_pattern_classes
    return contact_hero_pattern_classes if object.contact.present?
    return account_hero_pattern_classes if object.account.present?
    return bot_hero_pattern_classes if object.bot.present?
  end

  private

  def contact_hero_pattern_classes
    contact.hero_pattern_classes
  end

  def account_hero_pattern_classes
    account.hero_pattern_classes
  end

  def bot_hero_pattern_classes
    bot.hero_pattern_classes
  end
end
