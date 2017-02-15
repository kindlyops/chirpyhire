class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_organization
  helper_method :impersonating?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_action :authenticate_account!
  before_action :block_invalid_subscriptions, unless: :devise_controller?

  include Pundit
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  include PublicActivity::StoreController

  impersonates(
    :account,
    method: :current_account,
    with: ->(id) { Account.find(id) }
  )

  def pundit_user
    current_organization
  end

  def current_organization
    @current_organization ||= current_user.organization
  end

  def current_user
    @current_user ||= current_account.user
  end

  def impersonated
    true_account != current_account
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

  def block_invalid_subscriptions
    redirect_to_current_subscription unless current_organization.good_standing?
  end

  def redirect_to_current_subscription
    redirect_to(subscription_path(current_organization.subscription))
  end

  def impersonating?
    current_account != true_account
  end
end
