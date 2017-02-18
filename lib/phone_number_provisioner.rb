class PhoneNumberProvisioner
  def initialize(organization)
    @organization = organization
  end

  def provision
    return if organization.phone_number.present?

    sub_account.incoming_phone_numbers.create(phone_number_attributes)
    organization.update(update_params)
  end

  def deprovision
    return if organization.phone_number.blank?

    sub_account.update(status: 'closed')
    organization.subscription.cancel
  end

  private

  def phone_number_attributes
    {
      phone_number: available_local_phone_number,
      voice_url: nil,
      sms_url: "#{ENV.fetch('TWILIO_WEBHOOK_BASE')}/twilio/text",
      capabilities: {
        voice: false,
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
        master_client.accounts.create(friendly_name: organization.name)
      end
    end
  end

  def available_local_phone_numbers
    @available_local_phone_numbers ||= begin
      local_numbers = sub_account.available_phone_numbers.get('US').local
      local_numbers.list(in_zip_code: organization.zip_code)
    end
  end

  def available_local_phone_number
    available_local_phone_numbers[0].phone_number
  end

  def update_params
    params = { phone_number: available_local_phone_number }
    return params if organization.twilio_account_sid.present?

    params.merge(
      twilio_account_sid: sub_account.sid,
      twilio_auth_token: sub_account.auth_token
    )
  end

  def master_client
    Messaging::Client.master
  end

  attr_reader :organization
end
