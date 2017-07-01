class Teams::MessagesController < ActionController::Base
  protect_from_forgery with: :null_session
  after_action :set_header

  def create
    MessageSyncerJob.perform_later(contact, params['MessageSid'], receipt: true)

    head :ok
  end

  private

  def contact
    @contact ||= begin
      contact = person.contacts.find_by(team: team)
      contact || create_subscribed_contact
    end
  end

  def person
    @person ||= Person.find_or_create_by(phone_number: params['From'])
  end

  def phone_number
    @phone_number ||= PhoneNumber.find_by(phone_number: params['To'])
  end

  def team
    @team ||= begin
      return unless phone_number && phone_number.assignment_rule
      phone_number.assignment_rule.team
    end
  end

  def create_subscribed_contact
    person.contacts.create(team: team).tap do |contact|
      contact.subscribe
      contact.create_contact_candidacy
    end
  end

  def set_header
    response.headers['Content-Type'] = 'text/xml'
  end
end
