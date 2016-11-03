class ZipcodeController < ApplicationController
  include ActionController::Live
  skip_before_action :block_invalid_subscriptions

  def geo_json
    skip_authorization # Zipcode data is consistent across organizations
    set_cache
    stream_data
  ensure
    response.stream.close
  end

  private

  attr_accessor :source

  def set_cache
    expires_in 365.days, public: true
    response.headers['Content-Type'] = 'text/event-stream'
  end

  # rubocop:disable Lint/HandleExceptions
  def stream_data
    begin
      loop { response.stream.write source.readpartial(1000) } if source.present?
    rescue EOFError
    end
  ensure
    source.close if Rails.env.development? && source.present?
  end
  # rubocop:enable Lint/HandleExceptions

  def source
    @source ||= source_stream
  end

  def source_stream
    relative_file_path = "geo_json_data/zipcodes/#{params[:zipcode]}.json"
    if Rails.env.development?
      File.open("#{Rails.root}/lib/#{relative_file_path}")
    else
      S3_BUCKET.object("#{relative_file_path}").get.body
    end
  rescue Errno::ENOENT, Aws::S3::Errors::AccessDenied
    Logging::Logger.log("No zipcode data for #{params[:zipcode]}")
    nil
  end
end
