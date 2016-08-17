class SessionsController < Devise::SessionsController
  after_action :prepare_intercom_shutdown, only: [:destroy]
  before_action :intercom_shutdown, only: [:new]

  private

  def prepare_intercom_shutdown
    IntercomRails::ShutdownHelper.prepare_intercom_shutdown(session)
  end

  def intercom_shutdown
    IntercomRails::ShutdownHelper.intercom_shutdown(session, cookies)
  end
end
