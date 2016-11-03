class ZipcodeController < ApplicationController
  include ActionController::Live
  skip_before_action :block_invalid_subscriptions

  def geo_json
    skip_authorization
    expires_in 365.days, public: true
    response.headers['Content-Type'] = 'text/event-stream'
    source = source_stream
    begin
      while true do
        response.stream.write source.readpartial(1000)
      end
    rescue EOFError
    end
  ensure
    response.stream.close
    source.close if Rails.env.development? && source.present?
  end

  private

  def source_stream
    zipcode = params[:zipcode]
    if Rails.env.development?
      File.open("#{Rails.root}/../geo_json_pre_convert_to_zip/zipcodes/#{zipcode}.json")
    else
      S3_BUCKET.object("geo_json_data/zipcodes/#{zipcode}.json").get.body
    end
  rescue Errno::ENOENT, Aws::S3::Errors::AccessDenied => e
    Logging::Logger.log("No zipcode data for #{zipcode}")
    nil
  end
end
