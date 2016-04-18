class Referral < ActiveRecord::Base
  belongs_to :lead
  belongs_to :referrer
  belongs_to :message

  delegate :organization, to: :lead

  def sms_response
    Sms::Response.new do |r|
      r.Message "Awesome! Please copy and text to #{lead.first_name}:"
      r.Message "Hey #{lead.first_name}. My home care agency, \
       #{organization.name}, regularly hires caregivers. They \
       treat me very well and have great clients. I think you \
       would be a great fit here. Text CARE to #{organization.phone_number} \
       to learn about opportunities."
    end
  end
end
