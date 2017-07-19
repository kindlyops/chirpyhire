class PhoneNumberProvisioner
  def initialize(team)
    @team = team
  end

  def self.provision(team)
    new(team).provision
  end

  def provision
    return if team.phone_number.present?

    phone_number.tap do |phone_number|
      organization.assignment_rules.create!(
        phone_number: phone_number, inbox: inbox
      )
    end
  end

  private

  def phone_number_attributes
    {
      phone_number: available_local_phone_number.phone_number,
      voice_url: "#{ENV.fetch('TWILIO_WEBHOOK_BASE')}/twilio/voice.xml",
      sms_url: "#{ENV.fetch('TWILIO_WEBHOOK_BASE')}/twilio/text",
      capabilities: {
        voice: true,
        sms: true,
        mms: true
      }
    }
  end

  def sub_account
    @sub_account ||= begin
      if organization.twilio_account_sid.present?
        master_client.accounts.get(organization.twilio_account_sid)
      else
        create_sub_account
      end
    end
  end

  def create_sub_account
    sub_account = request_sub_account
    organization.update(
      twilio_account_sid: sub_account.sid,
      twilio_auth_token: sub_account.auth_token
    )
    sub_account
  end

  def request_sub_account
    master_client.accounts.create(friendly_name: organization.name)
  end

  def available_local_phone_numbers
    @available_local_phone_numbers ||= begin
      local_numbers = sub_account.available_phone_numbers.get('US').local
      lat_long = "#{location.latitude},#{location.longitude}"
      local_numbers.list(
        near_lat_long: lat_long,
        in_region: location.state_code.to_s
      )
    end
  end

  def available_local_phone_number
    @available_local_phone_number ||= available_local_phone_numbers[0]
  end

  def phone_number
    @phone_number ||= organization.phone_numbers.create!(phone_params)
  end

  def inbox
    @inbox ||= (team.inbox || team.create_inbox!)
  end

  def new_twilio_number
    @new_twilio_number ||= begin
      sub_account.incoming_phone_numbers.create(phone_number_attributes)
    end
  end

  def phone_params
    {
      phone_number: new_twilio_number.phone_number,
      forwarding_phone_number: organization.forwarding_phone_number,
      sid: new_twilio_number.sid
    }
  end

  def master_client
    Messaging::Client.master
  end
  attr_reader :team
  delegate :location, :organization, to: :team
end
