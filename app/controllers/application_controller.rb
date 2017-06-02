class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_organization
  helper_method :current_inbox
  helper_method :impersonating?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :authenticate_account!

  extend Pretender
  impersonates :account

  def current_organization
    @current_organization ||= current_account.organization
  end

  def current_inbox
    @current_inbox ||= current_account.inbox
  end

  def impersonated
    true_account != current_account
  end

  include Pundit
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_account
  end

  def true_organization
    @true_organization ||= true_account.organization
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t(
      "#{policy_name}.#{exception.query}",
      scope: 'pundit',
      default: :default
    )

    redirect_to(request.referer || root_path)
  end

  def impersonating?
    current_account != true_account
  end
end
