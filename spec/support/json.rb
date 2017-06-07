module ResponseJson
  def response_json
    JSON.parse(response.body)
  end
end

RSpec.configure do |c|
  c.include ResponseJson, type: :controller
  c.include ResponseJson, type: :request
end
