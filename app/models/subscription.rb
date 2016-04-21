class Subscription < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :organization

  delegate :owner_first_name, to: :organization
  delegate :first_name, to: :user, prefix: true

  def sms_response
    Sms::Response.new do |r|
      r.Message "#{user_first_name}, this is #{owner_first_name} at #{organization.name}. \
I'm so glad you are interested in learning about opportunities here. \
When we have a need we'll send out a few text messages asking you questions \
about your availability and experience. If you ever wish to stop receiving \
text messages just reply STOP. Thanks again for your interest!"
    end
  end
end
