class ZipcodeController < ApplicationController
  include ActionController::Live
  skip_before_action :block_invalid_subscriptions

  def geo_json
    binding.pry
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
    relative_file_path = "geo_json_data/zipcodes/"
    if Rails.env.development?
      File.open("#{Rails.root}/../geo_json_pre_convert_to_zip/zipcodes/#{zipcode}.json")
    else
      S3_BUCKET.object(relative_file_path).get.body
    end
  rescue Errno::ENOENT, Aws::S3::Errors::AccessDenied => e
    puts "COULDN'T FIND #{zipcode}"
    Logging::Logger.log("No zipcode data for #{zipcode}")
    nil
  end
end
