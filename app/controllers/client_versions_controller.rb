class ClientVersionsController < ApplicationController
  skip_after_action :verify_authorized
  skip_before_action :authenticate_account!

  def show
    render json: client_version
  end

  private

  def client_version
    ENV.fetch('CLIENT_VERSION')
  end
end
