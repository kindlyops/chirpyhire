if Rails.env.test?
  Address::URI_BASE = "http://localhost"
else
  Address::URI_BASE = ENV.fetch("ADDRESS_URI_BASE")
end
