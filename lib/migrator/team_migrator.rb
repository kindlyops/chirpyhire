class Migrator::TeamMigrator
  def initialize(organizations:, accounts:, team:)
    @organizations = organizations
    @accounts = accounts
    @team = team
    @phone_number = @team.phone_number
  end

  attr_reader :team, :accounts, :organizations, :phone_number
  delegate :location, :recruiting_ad, :contacts, to: :team

  def migrate
    Team.transaction do
      update_old_team_phone_number
      created_recruiting_ad
      create_memberships
      contacts.find_each do |contact|
        Migrator::ContactMigrator.new(self, contact).migrate
      end
    end
  end

  def created_team
    @created_team ||= begin
      organizations[:to].teams.create!(
        name: team.name,
        recruiter: accounts.first[:to],
        phone_number: phone_number,
        location_attributes: location_attributes
      )
    end
  end

  private

  def update_old_team_phone_number
    updated_phone_number = "MIGRATED:#{phone_number}"
    Rails.logger.info "Updating Team #{team.id} Phone Number to #{updated_phone_number}"
    team.update!(phone_number: updated_phone_number)
    Rails.logger.info "Updated Team #{team.id} Phone Number to #{updated_phone_number}"
  end

  def create_memberships
    accounts.each do |account|
      join_team(account[:to])
    end
  end

  def join_team(to_account)
    Rails.logger.info "Account: #{to_account.id} joining Team: #{created_team.id}"
    created_team.accounts << to_account
    Rails.logger.info "Account: #{to_account.id} joined Team: #{created_team.id}"
  end

  def created_recruiting_ad
    @created_recruiting_ad ||= begin
      Rails.logger.info "Creating Recruiting Ad for Team: #{created_team.id}"
      ad = created_team.create_recruiting_ad(recruiting_ad_attributes)
      Rails.logger.info "Created Recruiting Ad: #{ad.id}"
      ad
    end
  end

  def recruiting_ad_attributes
    {
      organization: organizations[:to],
      body: recruiting_ad.body,
      created_at: recruiting_ad.created_at,
      updated_at: recruiting_ad.updated_at
    }
  end

  def location_attributes
    location.attributes.except('id', 'team_id')
            .merge('organization_id' => organizations[:to].id)
  end
end
