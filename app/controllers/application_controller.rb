class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_organization
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :authenticate_account!

  include Pundit
  after_action :verify_authorized, except: :index, unless: :engine_controller?
  after_action :verify_policy_scoped, only: :index, unless: :engine_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_organization
  end

  def current_organization
    @current_organization ||= current_user.organization
  end

  def current_user
    @current_user ||= current_account.user
  end

  private

  def engine_controller?
    is_a?(Payola::ApplicationController) || devise_controller?
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end

  def user_for_paper_trail
  end
end
