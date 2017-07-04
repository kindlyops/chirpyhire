class Seeder
  def seed
    account = Seeder::SeedAccount.call
    bot = BotMaker::DefaultBot.call(account.organization)
    create_bot_campaigns(account.organization, bot)
    Seeder::SeedContacts.call(account)
    Seeder::SeedMetrics.call(account)
  end

  private

  def create_bot_campaigns(organization, bot)
    campaign = organization.campaigns.find_or_create_by(name: bot.name)
    organization.teams.find_each do |team|
      bot.bot_campaigns.create(inbox: team.inbox, campaign: campaign)
    end
  end
end
