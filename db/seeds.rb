# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  puts "Creating Organization"
  org = Organization.find_or_create_by!(
    name: "Happy Home Care",
    twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
    phone_number: ENV.fetch("TEST_ORG_PHONE")
  )
  puts "Created Organization"

  puts "Creating User"
  user = User.find_or_create_by!(
   first_name: "Harry",
   last_name: "Whelchel",
   phone_number: ENV.fetch("DEV_PHONE"),
   organization: org
  )
  puts "Created User"

  puts "Creating Account"
  email = ENV.fetch("DEV_EMAIL")
  unless user.account.present?
    user.create_account!(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
  end
  puts "Created Account"

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)
  puts "Created Referrer"

  unless org.templates.present?
    welcome = org.templates.create!(name: "Welcome", body: "Hello this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = org.templates.create!(name: "Thank You", body: "Thanks for your interest!")
    puts "Created Templates"
  end

  unless org.candidate_persona.persona_features.present?
    org.candidate_persona.create_template(organization: org, name: "Bad Fit - Default", body: "Thank you very much for your interest. Unfortunately, we don't have a good fit for you at this time. If anything changes we will let you know.")
    org.candidate_persona.persona_features.create!(priority: 1, category: Category.create(name: "Address"), format: "address", text: "Address and Zipcode", properties: { distance: 20, latitude: 33.929966, longitude: -84.373931 })
    org.candidate_persona.persona_features.create!(priority: 2, category: Category.create(name: "TB Test"), format: "document", text: "TB Test")
    org.candidate_persona.persona_features.create!(priority: 3, category: Category.create(name: "CNA License"), format: "document", text: "CNA License")
    puts "Created Profile Features"
  end

  unless org.rules.present?
    subscribe_rule = org.rules.create!(trigger: "subscribe", actionable: welcome.create_actionable)
    subscribe_rule_2 = org.rules.create!(trigger: "subscribe", actionable: org.candidate_persona.create_actionable)
    answer_rule = org.rules.create!(trigger: "answer", actionable: org.candidate_persona.actionable)
    screen_rule = org.rules.create!(trigger: "screen", actionable: thank_you.create_actionable)
    puts "Created Rules"
  end

  # unless user.activities.present?
  #   raw_messages = org.send(:messaging_client).messages.list.select do |message|
  #     message.direction == "inbound"
  #   end

  #   bodies = ["Will my CNA license from Florida transfer?",
  #             "Will you hire me if I just have my PCA?"]

  #   NEEDED_SIDS = ["MMcb3589b5256ee750a86f05dc5e418e31", "SM3ca817b0df3d27e633d0eaa111d5561c", "SM141d3c61f986414fb8db473078e68b24"]

  #   needed_messages = raw_messages.select{|m| NEEDED_SIDS.include?(m.sid) }
  #   needed_messages.each do |message|
  #     MessageHandler.call(user, Messaging::Message.new(message))
  #   end

  #   ok_messages = raw_messages.reject{|m| NEEDED_SIDS.include?(m.sid) }

  #   2.times do |i|

  #     message = MessageHandler.call(user, Messaging::Message.new(ok_messages[i]))
  #     message.update!(body: bodies[i], created_at: rand(6.hours.ago..Time.now))

  #     FactoryGirl.create!(:activity, user: user, trackable: message)
  #   end

  #   FactoryGirl.create!(:activity, user: user, trackable: user.candidate)
  #   puts "Created Tasks"
  # end

  # unless user.inquiries.present?
  #   candidate_persona = org.candidate_persona
  #   inquiry = ProfileAdvancer.call(user.candidate)
  #   sids = {
  #     document: "MMcb3589b5256ee750a86f05dc5e418e31",
  #     address: "SM3ca817b0df3d27e633d0eaa111d5561c"
  #   }
  #   first_answer_message = Message.find_by(sid: sids[inquiry.format.to_sym])
  #   first_answer_message.update!(created_at: 4.hours.ago)
  #   inquiry.message.update!(created_at: 4.hours.ago - 5.minutes)
  #   inquiry.create_answer!(message: first_answer_message)
  #   inquiry = ProfileAdvancer.call(user.candidate)
  #   second_answer_message = Message.find_by(sid: sids[inquiry.format.to_sym])
  #   second_answer_message.update!(created_at: 3.hours.ago)
  #   inquiry.message.update!(created_at: 3.hours.ago - 5.minutes)
  #   address_answer = inquiry.create_answer!(message: second_answer_message)

  #   candidate.candidate_features.last.update!(properties: Address.extract(second_answer_message))

  #   puts "Created Inquiries, Answers"
  # end

  # unless user.notifications.present?
  #   thank_you = org.templates.find_by(body: "Thanks for your interest!")
  #   thank_you_sid = "SM141d3c61f986414fb8db473078e68b24"

  #   thank_you_message = Message.find_or_create_by!(user: user, sid: thank_you_sid, body: thank_you.body, direction: "outbound-api")
  #   thank_you_message.update!(created_at: 2.hours.ago)
  #   thank_you.notifications.create!(message: thank_you_message)

  #   puts "Created Notification"
  # end

  puts "Development specific seeding completed"
end

puts "Seed completed"


### Pilot Seed ###

# organization = Organization.find_by(name:)
# organization.update(twilio_account_sid:,twilio_auth_token:,phone_number:)

# welcome = organization.templates.create!(name: "Welcome", body: "Hello this is {{organization.name}}. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
# thank_you = organization.templates.create!(name: "Thank You", body: "Thanks for your interest!")

# subscribe_rule = organization.rules.create!(trigger: "subscribe", action: welcome)
# subscribe_rule_2 = organization.rules.create!(trigger: "subscribe", action: organization.candidate_persona)
# answer_rule = organization.rules.create!(trigger: "answer", action: organization.candidate_persona)
# screen_rule = organization.rules.create!(trigger: "screen", action: thank_you)

# organization.candidate_persona.features.create!(format:, name:)

