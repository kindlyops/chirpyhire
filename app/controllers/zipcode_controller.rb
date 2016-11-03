class ZipcodeController < ApplicationController
  include ActionController::Live
  skip_before_action :block_invalid_subscriptions
  before_action :skip_authorization

  # rubocop:disable Lint/HandleExceptions
  def geo_json
    set_cache
    source = source_stream
    begin
      loop { response.stream.write source.readpartial(1000) if source.present? }
    rescue EOFError
    end
  ensure
    response.stream.close
    source.close if Rails.env.development? && source.present?
  end
  # rubocop:enable Lint/HandleExceptions

  private

  def set_cache
    expires_in 365.days, public: true
    response.headers['Content-Type'] = 'text/event-stream'
  end

  def source_stream
    zipcode = params[:zipcode]
    if Rails.env.development?
      File.open("#{Rails.root}/lib/geo_json_data/zipcodes/#{zipcode}.json")
    else
      S3_BUCKET.object("geo_json_data/zipcodes/#{zipcode}.json").get.body
    end
  rescue Errno::ENOENT, Aws::S3::Errors::AccessDenied
    Logging::Logger.log("No zipcode data for #{zipcode}")
    nil
  end
end
