class Subscription < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :lead

  delegate :organization_name, :owner_first_name, to: :lead
  delegate :first_name, to: :lead, prefix: true

  def sms_response
    if deleted_at.blank?
      Sms::Response.new do |r|
        r.Message "#{lead_first_name}, this is #{owner_first_name} at #{organization_name}. \
I'm so glad you are interested in learning about opportunities here. \
When we have a need we'll send out a few text messages asking you questions \
about your availability and experience. If you ever wish to stop receiving \
text messages just reply STOP. Thanks again for your interest!"
      end
    else
      Sms::Response.new do |r|
        r.Message "You are unsubscribed. To subscribe reply with START. Thanks for your interest in #{organization_name}."
      end
    end
  end
end
