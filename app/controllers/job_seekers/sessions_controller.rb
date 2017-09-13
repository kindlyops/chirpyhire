class JobSeekers::SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_user, only: :destroy
  after_action :prepare_intercom_shutdown, only: [:destroy]
  after_action :intercom_shutdown, only: [:index]

  private

  def prepare_intercom_shutdown
    IntercomRails::ShutdownHelper.prepare_intercom_shutdown(session)
  end

  def intercom_shutdown
    IntercomRails::ShutdownHelper.intercom_shutdown(session, cookies)
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
