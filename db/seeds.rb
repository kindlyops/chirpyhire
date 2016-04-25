# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

question_templates = [
  {
    title: "Bathing",
    body: "Can you assist someone with bathing?",
    statement: "who can assist with bathing",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Depression",
    body: "Can you comfort someone depressed?",
    statement: "who can assist with depression",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Cooking",
    body: "Can you cook meals?",
    statement: "who can cook meals",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Dressing, Shaving, & Grooming",
    body: "Can you assist with dressing, shaving, and grooming?",
    statement: "who can assist with dressing, shaving, and grooming",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Meal Prep & Eating",
    body: "Can you assist with preparing meals and eating?",
    statement: "who can assist with preparing meals and eating",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Toileting/Continence",
    body: "Can you assist with toileting and continence?",
    statement: "who can assist with toileting and continence",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Wound Care",
    body: "Can you assist with wound care?",
    statement: "who can assist with wound care",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Dementia",
    body: "Do you have experience with dementia?",
    statement: "who has experience with dementia",
    category: QuestionTemplate.categories[:experience]
  },
  {
    title: "Hospice",
    body: "Do you have experience with hospice?",
    statement: "who has experience with hospice",
    category: QuestionTemplate.categories[:experience]
  },
  {
    title: "Parkinson's",
    body: "Do you have experience with Parkinson's?",
    statement: "who has experience with Parkinson's",
    category: QuestionTemplate.categories[:experience]
  },
  {
    title: "Laundry",
    body: "Can you assist with laundry?",
    statement: "who can assist with laundry",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Light Housekeeping",
    body: "Can you assist with light housekeeping?",
    statement: "who can assist with light housekeeping",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Medication Reminders & Prep",
    body: "Can you assist with medication reminders and prep?",
    statement: "who can assist with medication reminders and prep",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Shopping & Errands",
    body: "Can you assist with shopping and errands?",
    statement: "who can assist with shopping and errands",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Can Transport Client by Automobile",
    body: "Can you assist with transporting clients by automobile?",
    statement: "who can assist with transporting clients by automobile",
    category: QuestionTemplate.categories[:transportation]
  },
  {
    title: "Has Insured Automobile",
    body: "Do you have an insured automobile?",
    statement: "who has an insured automobile",
    category: QuestionTemplate.categories[:transportation]
  },
  {
    title: "Ok with smoking",
    body: "Is it ok if your client smokes?",
    statement: "who is ok with clients smoking",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Live-in Shifts",
    body: "Are you ok working live-in shifts?",
    statement: "who is ok working live-in shifts",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Night Shifts",
    body: "Are you ok working night shifts?",
    statement: "who is ok working night shifts",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Transfers",
    body: "Do you have experience with transfers in/out of wheelchairs and/or beds?",
    statement: "who has experience with wheelchair and/or bed transfers",
    category: QuestionTemplate.categories[:experience]
  },
  {
    title: "Gait Belt",
    body: "Do you have experience with a gait belt?",
    statement: "who has experience with gait belts",
    category: QuestionTemplate.categories[:experience]
  },
  {
    title: "Hoyer Lift",
    body: "Do you have experience with a hoyer lift?",
    statement: "who has experience with a hoyer lift",
    category: QuestionTemplate.categories[:experience]
  },
  {
    title: "Ok with cats",
    body: "Are you ok with cats?",
    statement: "who is ok with cats",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Ok with dogs",
    body: "Are you ok with dogs?",
    statement: "who is ok with dogs",
    category: QuestionTemplate.categories[:preferences]
  },
  {
    title: "Chest X-Ray",
    body: "Do you have a current chest x-ray?",
    statement: "who has a current chest x-ray",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "CNA License",
    body: "Do you have a current CNA license?",
    statement: "who has a current CNA license",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "Driver's License",
    body: "Do you have a current driver's license?",
    statement: "who has a current driver's license",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "First Aid Certification",
    body: "Do you have a current first aid certification?",
    statement: "who has a current first aid certification",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "CPR Certification",
    body: "Do you have a current CPR certification?",
    statement: "who has a current CPR certification",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "HHA Certification",
    body: "Do you have a current HHA certification?",
    statement: "who has a current HHA certification",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "Registered Nurse",
    body: "Are you a current registered nurse?",
    statement: "who is a current registered nurse",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "Tuberculosis Test",
    body: "Do you have a current Tuberculosis test?",
    statement: "who has a current Tuberculosis test",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "LVN/LPN Certification",
    body: "Do you have a current LVN/LPN certification?",
    statement: "who has a current LVN/LPN certification",
    category: QuestionTemplate.categories[:credentials]
  },
  {
    title: "7am - 3pm",
    body: "Can you work 7am - 3pm?",
    statement: "who can work 7am - 3pm",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "3pm - 11pm",
    body: "Can you work 3pm - 11pm?",
    statement: "who can work 3pm - 11pm",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "11pm - 7am",
    body: "Can you work 11pm - 7am?",
    statement: "who can work 11pm - 7am",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "MWF",
    body: "Can you work Monday, Wednesday, and Friday?",
    statement: "who can work Monday, Wednesday, and Friday",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "TTh",
    body: "Can you work Tuesday and Thursday?",
    statement: "who can work Tuesday and Thursday",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Saturday",
    body: "Can you work Saturdays?",
    statement: "who can work Saturdays",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Sunday",
    body: "Can you work Sundays?",
    statement: "who can work Sundays",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Monday",
    body: "Can you work Mondays?",
    statement: "who can work Mondays",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Tuesday",
    body: "Can you work Tuesdays?",
    statement: "who can work Tuesdays",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Wednesday",
    body: "Can you work Wednesdays?",
    statement: "who can work Wednesdays",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Thursday",
    body: "Can you work Thursdays?",
    statement: "who can work Thursdays",
    category: QuestionTemplate.categories[:schedule]
  },
  {
    title: "Friday",
    body: "Can you work Fridays?",
    statement: "who can work Fridays",
    category: QuestionTemplate.categories[:schedule]
  }
]

QuestionTemplate.create(question_templates) unless QuestionTemplate.exists?

org = Organization.find_or_create_by(
  name: "Happy Home Care",
  twilio_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
  twilio_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN")
)

user = User.find_or_create_by(
 first_name: "Harry",
 last_name: "Whelchel",
 phone_number: "+14047908943"
)

email = "harrywhelchel@gmail.com"
unless Account.where(email: email).exists?
  account = Account.create(password: "password", password_confirmation: "password", role: Account.roles[:owner], user: user, organization: org, email: email, super_admin: true)
end

Phone.find_or_create_by(title: "#{org.name} Referrals", number: "+16788417816", organization: org)
Referrer.find_or_create_by(user: user, organization: org)
lead = Lead.find_or_create_by(organization: org, user: user)
lead.subscribe unless lead.subscribed?

unless Referrer.count > 30
  referrers = FactoryGirl.create_list(:referrer, 32, organization: org)
  referrers.each do |referrer|
    referrer.refer(FactoryGirl.create(:lead, :without_phone_number, organization: org), FactoryGirl.create(:message, organization: org))
  end
  26.times { org.leads.sample.subscribe }
end

account = Account.find_by(email: email)
searches = FactoryGirl.create_list(:search, 5, account: account)

searches.each do |search|
  search.leads << org.leads
end

searches.take(3).each do |search|
  search.search_leads.sample.good_fit!
end

