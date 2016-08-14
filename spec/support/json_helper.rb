module JsonHelper
  def response_json
    JSON.parse(response.body)
  end
end

RSpec.configure do |c|
  c.include JsonHelper, type: :controller
end
