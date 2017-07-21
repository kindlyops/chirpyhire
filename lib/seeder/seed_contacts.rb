class Seeder::SeedContacts
  def self.call(account)
    new(account).call
  end

  def initialize(account)
    @account = account
  end

  def call
    return if organization.contacts.exists?

    Seeder::SeedContact.call(account, demo_contact)
    contacts.each do |contact|
      Seeder::SeedContact.call(account, contact)
    end
  end

  attr_reader :account
  delegate :organization, to: :account

  def contacts
    FactoryGirl.create_list(:contact, demo_amount, :complete, contact_params)
  end

  def demo_contact
    @demo_contact ||= begin
      FactoryGirl.create(:contact, :complete, contact_params).tap do |contact|
        contact.person.update(nickname: demo_nickname, phone_number: demo_phone)
      end
    end
  end

  def contact_params
    {
      subscribed: true,
      organization: organization,
      stage: organization.contact_stages.first
    }
  end

  def demo_nickname
    ENV.fetch('DEMO_NICKNAME')
  end

  def demo_phone
    ENV.fetch('DEMO_PHONE')
  end

  def demo_amount
    ENV.fetch('DEMO_SEED_AMOUNT').to_i
  end
end
