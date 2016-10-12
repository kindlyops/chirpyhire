longitude = ENV.fetch("longitude", -84.373931).to_f
latitude = ENV.fetch("latitude", 33.929966).to_f


if Rails.env.development?
  if Plan.count > 0
    plan = Plan.first
  else
    plan = Plan.create(amount: Plan::DEFAULT_PRICE_IN_DOLLARS * 100, interval: 'month', stripe_id: ENV.fetch("TEST_STRIPE_PLAN_ID", "1"), name: 'Basic')
  end

  puts "Created Plan"

  puts "Creating Organization"
  org = Organization.find_or_create_by!(
    name: "Happy Home Care",
    twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
    twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
    phone_number: ENV.fetch("TEST_ORG_PHONE"),
    stripe_customer_id: ENV.fetch("TEST_STRIPE_CUSTOMER_ID", "cus_90xvMZp8CMvOE9")
  )

  org.create_subscription(plan: plan, state: "trialing", trial_message_limit: 1000)
  puts "Created Subscription"

  location = FactoryGirl.create(:location, latitude: latitude, longitude: longitude, organization: org)
  puts "Created Location"

  puts "Creating User"
  user = User.find_or_create_by!(
   first_name: "Harry",
   last_name: "Whelchel",
   phone_number: ENV.fetch("DEV_PHONE"),
   organization: org
  )

  puts "Creating Account"
  email = ENV.fetch("DEV_EMAIL")
  unless user.account.present?
    user.create_account!(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
  end

  puts "Creating Referrer"
  Referrer.find_or_create_by(user: user)

  unless org.survey.present?
    bad_fit = Template.create(organization: org, name: "Bad Fit", body: "Thank you very much for your interest. Unfortunately, we don't "\
      "have a good fit for you at this time. If anything changes we will let you know.")
    welcome = Template.create(organization: org, name: "Welcome", body: "Hello this is Chirpyhire. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
    thank_you = Template.create(organization: org, name: "Thank You", body: "Thanks for your interest! Please give us a call at 404-867-5309 during the week between 9am - 5pm for next steps.")
    survey = org.create_survey(bad_fit: bad_fit, welcome: welcome, thank_you: thank_you)
  end

  unless org.survey.questions.present?
    address_question = org.survey.questions.create!(priority: 1, label: "Address", type: AddressQuestion.name, text: "What is your address and zipcode?")
    address_question.create_address_question_option(distance: 20, latitude: latitude, longitude: longitude )
    choice_question = org.survey.questions.create!(priority: 2, label: "Availability", type: ChoiceQuestion.name, text: "What is your availability?",
      choice_question_options_attributes: [
        {text: "Live-in", letter: "a"},
        {text: "Hourly", letter: "b"},
        {text: "Both", letter: "c"},
        ])
    yes_no_question = org.survey.questions.create(priority: 3, label: "Transportation", type: YesNoQuestion.name, text: "Do you have reliable personal transportation?")
    zipcode_question = org.survey.questions.create!(priority: 4, label: "Zipcode", type: ZipcodeQuestion.name, text: "What is your zipcode?",
      zipcode_question_options_attributes: [
        {text: "30342"},
        {text: "30327"}
        ])
    puts "Created Questions"
  end

  unless org.rules.present?
    subscribe_rule = org.rules.create!(trigger: "subscribe", actionable: org.survey.create_actionable)
    answer_rule = org.rules.create!(trigger: "answer", actionable: org.survey.actionable)
    screen_rule = org.rules.create!(trigger: "screen", actionable: thank_you.create_actionable)
    puts "Created Rules"
  end

  def random_coordinate(seed_coordinate)
    rand((seed_coordinate - 0.3)..(seed_coordinate + 0.3))
  end

  puts "Creating Candidates"
  Stage.standard_stage_mappings.keys.each do |stage_name|
    stage = org.send("#{stage_name}_stage")
    25.times do |i|
      if i % 5 > 0
        FactoryGirl.create(:candidate, :with_address, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), stage: stage, organization: org, created_at: rand(1.month).seconds.ago)
      else
        FactoryGirl.create(:candidate, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), stage: stage, organization: org, created_at: rand(1.month).seconds.ago)
      end
    end
  end

  def create_exchange(candidate, question, question_class, label, response_body, successful = true)
    query = FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: question.formatted_text)
    inquiry = FactoryGirl.create(:inquiry, message: query, question: question)
    response = FactoryGirl.create(:message, user: candidate.user, direction: "inbound", body: response_body)
    FactoryGirl.create(:candidate_feature, candidate: candidate, label: label, properties: question_class.extract(response, inquiry))

    if !successful
      FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: "Thank you very much for your interest. Unfortunately, we don't "\
      "have a good fit for you at this time. If anything changes we will let you know.")
    end
  end

  puts "Creating Candidates' conversations"
  Candidate.find_each do |candidate|
    if candidate.address.present?
      address_query = FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: "#{welcome.body}\n\nIf you ever wish to stop receiving text messages from #{org.name} just reply STOP.\n\n#{address_question.formatted_text}")
      address_inquiry = FactoryGirl.create(:inquiry, message: address_query, question: address_question)
      address_response = FactoryGirl.create(:message, user: candidate.user, direction: "inbound", body: candidate.address.formatted_address)
    end

    create_exchange(candidate, choice_question, ChoiceQuestion, "Availability", %w(a b c).sample)
  end

  Candidate.bad_fit.find_each do |candidate|
    if (candidate.address.blank?) 
      create_exchange(candidate, yes_no_question, YesNoQuestion, "Transportation", "Yes")
      create_exchange(candidate, zipcode_question, ZipcodeQuestion, "Zipcode", "30305", false)
    else
      create_exchange(candidate, yes_no_question, YesNoQuestion, "Transportation", "No", false)
    end
  end
  puts 'Finished bad fit candidates'

  Candidate.qualified.or(Candidate.hired).find_each do |candidate|
    create_exchange(candidate, yes_no_question, YesNoQuestion, "Transportation", "Yes")

    if candidate.address.blank?
      create_exchange(candidate, zipcode_question, ZipcodeQuestion, "Zipcode", "30327")
    end

    FactoryGirl.create(:candidate_feature, candidate: candidate, label: "CNA License", properties: {
      child_class: "document",
      url0: "http://www.rejuven8bykelly.com/yahoo_site_admin/assets/images/CNAlic2012.20143437_std.jpg"
    })
    FactoryGirl.create(:message, :with_image, user: candidate.user, direction: "inbound")
    FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: thank_you.body)
  end
  puts 'Finished hired/qualified candidates'

  puts "Development specific seeding completed"
end

puts "Seed completed"
