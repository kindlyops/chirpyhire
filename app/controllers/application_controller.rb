class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_account!

  def organization
    @organization ||= current_account.organization
  end

  def leads
    @leads ||= organization.leads
  end
end
