class Seeder
  def initialize
    @longitude = ENV.fetch("longitude", -84.373931).to_f
    @latitude = ENV.fetch("latitude", 33.929966).to_f
    @zipcodes = ENV.fetch("zipcodes", ["30342", "30327", "30305", "30306", "30307"])
    @seed_location_type = ENV.fetch("SEED_LOCATION_TYPE", "address")
  end

  def seed
    create_plan
    create_organization
    create_dev_user
    create_dev_account
    create_referrer
    create_survey
    create_survey_rules
    create_candidates
    create_candidate_message_exchanges
  end

  private

  def create_candidate_message_exchanges
    Candidate.find_each do |candidate|
      location_query = FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: "#{welcome.body}\n\nIf you ever wish to stop receiving text messages from #{org.name} just reply STOP.\n\n#{location_question.formatted_text}")
      location_inquiry = FactoryGirl.create(:inquiry, message: location_query, question: location_question)
      location_response = case seed_location_type
        when 'address'
          candidate.address.formatted_address
        when 'zipcode'
          candidate.zipcode
      end
      FactoryGirl.create(:message, user: candidate.user, direction: "inbound", body: location_response)

      create_exchange(candidate, choice_question, ChoiceQuestion, "Availability", %w(a b c).sample)
    end

    Candidate.bad_fit.find_each do |candidate|
      create_exchange(candidate, yes_no_question, YesNoQuestion, "Transportation", "No", false)
    end

    Candidate.qualified.or(Candidate.hired).find_each do |candidate|
      create_exchange(candidate, yes_no_question, YesNoQuestion, "Transportation", "Yes")

      FactoryGirl.create(:candidate_feature, candidate: candidate, label: "CNA License", properties: {
        child_class: "document",
        url0: "http://www.rejuven8bykelly.com/yahoo_site_admin/assets/images/CNAlic2012.20143437_std.jpg"
      })
      FactoryGirl.create(:message, :with_image, user: candidate.user, direction: "inbound")
      FactoryGirl.create(:message, user: candidate.user, direction: "outbound-api", body: thank_you.body)
    end


    puts "Created Candidate message exchanges"
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

  def create_candidates
    Stage.standard_stage_mappings.keys.each do |stage_name|
      stage = org.send("#{stage_name}_stage")
      25.times do |i|
        if seed_location_type == 'address'
          FactoryGirl.create(:candidate, :with_address, latitude: random_coordinate(latitude), longitude: random_coordinate(longitude), stage: stage, organization: org, created_at: rand(1.month).seconds.ago)
        else
          FactoryGirl.create(:candidate, zipcode: zipcodes.sample, stage: stage, organization: org, created_at: rand(1.month).seconds.ago)
        end
      end
    end
    puts "Created Candidates"
  end

  def create_location_question(priority)
    if seed_location_type == "address"
      @location_question = org.survey.questions.create!(priority: priority, label: "Address", type: AddressQuestion.name, text: "What is your address and zipcode?")
      location_question.create_address_question_option(distance: 20, latitude: latitude, longitude: longitude )
    elsif seed_location_type == "zipcode"
      @location_question = org.survey.questions.create!(priority: priority, label: "Zipcode", type: ZipcodeQuestion.name, text: "What is your 5-digit zipcode?",
        zipcode_question_options_attributes: zipcodes.map { |z| { text: z } })
    end
  end

  def random_coordinate(seed_coordinate)
    rand((seed_coordinate - 0.3)..(seed_coordinate + 0.3))
  end

  def create_survey_rules
    unless org.rules.present?
      org.rules.create!(trigger: "subscribe", actionable: org.survey.create_actionable)
      org.rules.create!(trigger: "answer", actionable: org.survey.actionable)
      org.rules.create!(trigger: "screen", actionable: thank_you.create_actionable)
      puts "Created Rules"
    end
  end

  def create_survey
    unless org.survey.present?
      @bad_fit = Template.create(organization: org, name: "Bad Fit", body: "Thank you very much for your interest. Unfortunately, we don't "\
        "have a good fit for you at this time. If anything changes we will let you know.")
      @welcome = Template.create(organization: org, name: "Welcome", body: "Hello this is Chirpyhire. We're so glad you are interested in learning about opportunities here. We have a few questions to ask you via text message.")
      @thank_you = Template.create(organization: org, name: "Thank You", body: "Thanks for your interest! Please give us a call at 404-867-5309 during the week between 9am - 5pm for next steps.")
      @not_understood = Template.create(organization: org, name: "Not Understood", body: "We didn't quite get that. Please try "\
      'again, or a staff member will get back to you as soon as possible.')
      @survey = org.create_survey(bad_fit: bad_fit, welcome: welcome, thank_you: thank_you, not_understood: not_understood)
    end

    unless org.survey.questions.present?
      create_location_question(1)
      @choice_question = org.survey.questions.create!(priority: 2, label: "Availability", type: ChoiceQuestion.name, text: "What is your availability?",
        choice_question_options_attributes: [
          {text: "Live-in", letter: "a"},
          {text: "Hourly", letter: "b"},
          {text: "Both", letter: "c"},
          ])
      @yes_no_question = org.survey.questions.create(priority: 3, label: "Transportation", type: YesNoQuestion.name, text: "Do you have reliable personal transportation?")
      puts "Created Questions"
    end

    puts "Created Survey"
  end

  def create_referrer
    Referrer.find_or_create_by(user: user)
    puts "Created Referrer"
  end

  def create_dev_account
    email = ENV.fetch("DEV_EMAIL")
    unless user.account.present?
      user.create_account!(password: "password", password_confirmation: "password", user: user, email: email, super_admin: true)
    end
    puts "Created Account"
  end

  def create_dev_user
    @user = User.find_or_create_by!(
     first_name: "Harry",
     last_name: "Whelchel",
     phone_number: ENV.fetch("DEV_PHONE"),
     organization: org
    )
    puts "Created Development User"
  end

  def create_plan
    if Plan.count > 0
      @plan = Plan.first
    else
      @plan = Plan.create(amount: Plan::DEFAULT_PRICE_IN_DOLLARS * 100, interval: 'month', stripe_id: ENV.fetch("TEST_STRIPE_PLAN_ID", "1"), name: 'Basic')
    end
    puts 'Created Plan'
  end

  def create_organization
    @org = Organization.find_or_create_by!(
      name: "Happy Home Care",
      twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
      twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
      phone_number: ENV.fetch("TEST_ORG_PHONE"),
      stripe_customer_id: ENV.fetch("TEST_STRIPE_CUSTOMER_ID", "cus_90xvMZp8CMvOE9")
    )

    org.create_subscription(plan: plan, state: "trialing", trial_message_limit: 1000)
    FactoryGirl.create(:location, latitude: latitude, longitude: longitude, organization: org)

    puts 'Created Organization'
  end

  attr_accessor(
    :longitude,
    :latitude,
    :zipcodes,
    :seed_location_type,
    :plan,
    :org,
    :user,
    :survey,

    :bad_fit,
    :welcome,
    :thank_you,
    :not_understood,

    :location_question,
    :choice_question,
    :yes_no_question
  )
end
