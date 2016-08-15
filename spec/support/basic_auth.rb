module BasicAuth
  def http_login(username, password)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username,password)
  end
end

RSpec.configure do |config|
  config.include BasicAuth, type: :request
end
