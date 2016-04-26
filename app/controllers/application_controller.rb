class ApplicationController < ActionController::Base
  helper_method :current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_account!

  def organization
    @organization ||= current_account.organization
  end

  def subscribed_candidates
    @subscribed_candidates ||= organization.subscribed_candidates
  end

  def current_user
    @current_user ||= current_account.user
  end
end
