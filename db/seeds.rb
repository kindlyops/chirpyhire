# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

org = Organization.find_or_create_by(
  name: "Happy Home Care",
  domain: "lodestonetechnologies.co",
  twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
  twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN")
)

user = User.find_or_create_by(
 first_name: "Harry",
 last_name: "Whelchel",
 phone_number: "+14047908943"
)

Phone.create(title: "#{org.name} Referrals", number: "+16788417816", organization: org)

Referrer.find_or_create_by(user: user, organization: org)
