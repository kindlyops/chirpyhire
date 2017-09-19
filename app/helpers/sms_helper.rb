module SmsHelper
  def sms_link_to(label, phone_number)
    return link_to(label, "sms://#{phone_number}/?body=Start") if android?
    return link_to(label, "sms://#{phone_number}/&body=Start") if ios?
  end

  private

  def android?
    browser.platform.android?
  end

  def ios?
    browser.platform.ios?
  end
end
