class Seeder
  def seed
    account = Seeder::SeedAccount.call
    bot = BotFactory::Maker.call(account)
    create_bot_campaigns(account, bot)
    Seeder::SeedContacts.call(account)
  end

  private

  def create_bot_campaigns(account, bot)
    organization = account.organization

    organization.teams.find_each do |team|
      name = "#{bot.name} on call: #{team.name}"
      campaign = organization.campaigns.find_by(name: name)
      campaign ||= create_campaign(account, organization, name)
      bot.bot_campaigns.create(inbox: team.inbox, campaign: campaign)
    end
  end

  def create_campaign(account, organization, name)
    organization.campaigns.create(
      name: name,
      account: account,
      last_edited_by: account,
      last_edited_at: DateTime.current
    )
  end
end
