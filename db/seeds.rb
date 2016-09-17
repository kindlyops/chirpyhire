# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)

longitude = ENV.fetch('longitude', -84.373931).to_f
latitude = ENV.fetch('latitude', 33.929966).to_f

if Rails.env.development?
  if Plan.count.positive?
    plan = Plan.first
  else
    plan = Plan.create(amount: Plan::DEFAULT_PRICE_IN_DOLLARS * 100, interval: 'month', stripe_id: ENV.fetch('TEST_STRIPE_PLAN_ID', '1'), name: 'Basic')
  end

  puts 'Created Plan'

  puts 'Creating Organization'
  org = Organization.find_or_create_by!(
    name: 'Happy Home Care',
    twilio_account_sid: ENV.fetch('TWILIO_ACCOUNT_SID'),
    twilio_auth_token: ENV.fetch('TWILIO_AUTH_TOKEN'),
    phone_number: ENV.fetch('TEST_ORG_PHONE'),
    stripe_customer_id: ENV.fetch('TEST_STRIPE_CUSTOMER_ID', 'cus_90xvMZp8CMvOE9')
  )
  puts 'Created Organization'

  org.create_subscription(plan: plan, state: 'trialing', trial_message_limit: 1000)
  puts 'Created Subscription'

  location = FactoryGirl.create(:location, latitude: latitude, longitude: longitude, organization: org)
  puts 'Created Location'

  puts 'Creating User'
  user = User.find_or_create_by!(
    first_name: 'Harry',
    last_name: 'Whelchel',
    phone_number: ENV.fetch('DEV_PHONE'),
    organization: org
  )
  puts 'Created User'

  puts 'Creating Account'
  email = ENV.fetch('DEV_EMAIL')
  unless user.account.present?
    user.create_account!(password: 'password', password_confirmation: 'password', user: user, email: email, super_admin: true)
  end
  puts 'Created Account'

  puts 'Creating Referrer'
  Referrer.find_or_create_by(user: user)
  puts 'Created Referrer'

  unless org.survey.present?
    bad_fit = Template.create(organization: org, name: 'Bad Fit', body: "Thank you very much for your interest. Unfortunately, we don't "\
      'have a good fit for you at this time. If anything changes we will let you know.')
    welcome = Template.create(organization: org, name: 'Welcome', body: "Hello this is Chirpyhire. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = Template.create(organization: org, name: 'Thank You', body: 'Thanks for your interest! Please give us a call at 404-867-5309 during the week between 9am - 5pm for next steps.')
    survey = org.create_survey(bad_fit: bad_fit, welcome: welcome, thank_you: thank_you)
  end

  unless org.survey.questions.present?
    address_question = org.survey.questions.create!(priority: 1, label: 'Address', type: 'AddressQuestion', text: 'What is your address and zipcode?')
    address_question.create_address_question_option(distance: 20, latitude: latitude, longitude: longitude)
    choice_question = org.survey.questions.create!(priority: 2, label: 'Availability', type: 'ChoiceQuestion', text: 'What is your availability?',
                                                   choice_question_options_attributes: [
                                                     { text: 'Live-in', letter: 'a' }
                                                   ])
    choice_question.choice_question_options.create(text: 'Hourly', letter: 'b')
    choice_question.choice_question_options.create(text: 'Both', letter: 'c')
    yes_no_question = org.survey.questions.create(priority: 3, label: 'Transportation', type: 'YesNoQuestion', text: 'Do you have reliable personal transportation?')
    # cna_question = org.survey.questions.create!(priority: 4, label: "CNA License", type: "DocumentQuestion", text: "Please send us a photo of your CNA license.")
    puts 'Created Profile Features'
  end

  unless org.rules.present?
    subscribe_rule = org.rules.create!(trigger: 'subscribe', actionable: org.survey.create_actionable)
    answer_rule = org.rules.create!(trigger: 'answer', actionable: org.survey.actionable)
    screen_rule = org.rules.create!(trigger: 'screen', actionable: thank_you.create_actionable)
    puts 'Created Rules'
  end

  def random_coordinate(seed_coordinate)
    rand((seed_coordinate - 0.3)..(seed_coordinate + 0.3))
  end

  25.times { FactoryGirl.create(:candidate, :with_address, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), status: 'Bad Fit', organization: org, created_at: rand(1.month).seconds.ago) }
  25.times { FactoryGirl.create(:candidate, :with_address, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), status: 'Qualified', organization: org, created_at: rand(1.month).seconds.ago) }
  25.times { FactoryGirl.create(:candidate, :with_address, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), status: 'Potential', organization: org, created_at: rand(1.month).seconds.ago) }
  25.times { FactoryGirl.create(:candidate, :with_address, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), status: 'Hired', organization: org, created_at: rand(1.month).seconds.ago) }

  Candidate.find_each do |candidate|
    FactoryGirl.create(:message, user: candidate.user, direction: 'outbound-api', body: "#{welcome.body}\n\nIf you ever wish to stop receiving text messages from #{org.name} just reply STOP.\n\n#{address_question.formatted_text}")
    FactoryGirl.create(:message, user: candidate.user, direction: 'inbound', body: Faker::Address.street_address)
    FactoryGirl.create(:candidate_feature, candidate: candidate, label: 'Address', properties: {
                         child_class: 'address',
                         address: location.full_street_address,
                         latitude: location.latitude,
                         longitude: location.longitude,
                         postal_code: location.postal_code,
                         country: location.country,
                         city: location.city
                       })
    FactoryGirl.create(:message, user: candidate.user, direction: 'outbound-api', body: choice_question.formatted_text)
    FactoryGirl.create(:message, user: candidate.user, direction: 'inbound', body: %w(a b c).sample)
    FactoryGirl.create(:candidate_feature, candidate: candidate, label: 'Availability', properties: {
                         child_class: 'choice',
                         choice_option: 'Hourly'
                       })
    FactoryGirl.create(:message, user: candidate.user, direction: 'outbound-api', body: yes_no_question.formatted_text)
  end

  Candidate.bad_fit.find_each do |candidate|
    FactoryGirl.create(:message, user: candidate.user, direction: 'inbound', body: 'No')
    FactoryGirl.create(:candidate_feature, candidate: candidate, label: 'Transportation', properties: {
                         child_class: 'yes_no',
                         yes_no_option: 'No'
                       })
    FactoryGirl.create(:message, user: candidate.user, direction: 'outbound-api', body: bad_fit.body)
  end

  Candidate.where(status: %w(Hired Qualified)).find_each do |candidate|
    FactoryGirl.create(:message, user: candidate.user, direction: 'inbound', body: 'Yes')
    FactoryGirl.create(:candidate_feature, candidate: candidate, label: 'Transportation', properties: {
                         child_class: 'yes_no',
                         yes_no_option: 'Yes'
                       })
    # FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: cna_question.formatted_text)
    FactoryGirl.create(:candidate_feature, candidate: candidate, label: 'CNA License', properties: {
                         child_class: 'document',
                         url0: 'http://www.rejuven8bykelly.com/yahoo_site_admin/assets/images/CNAlic2012.20143437_std.jpg'
                       })
    FactoryGirl.create(:message, :with_image, user: candidate.user, direction: 'inbound')
    FactoryGirl.create(:message, user: candidate.user, direction: 'outbound-api', body: thank_you.body)
  end

  puts 'Development specific seeding completed'
end

puts 'Seed completed'
