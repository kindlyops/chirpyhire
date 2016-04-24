# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = [
  {name: "Preferences"},
  {name: "Experience"},
  {name: "Transportation"},
  {name: "Schedule"},
  {name: "Credentials"}
]

QuestionCategory.create(categories) unless QuestionCategory.exists?
preferences = QuestionCategory.find_by(name: "Preferences")
experience = QuestionCategory.find_by(name: "Experience")
schedule = QuestionCategory.find_by(name: "Schedule")
transportation = QuestionCategory.find_by(name: "Transportation")
credentials = QuestionCategory.find_by(name: "Credentials")

questions = [
  {
    title: "Bathing",
    body: "Can you assist someone with bathing?",
    statement: "who can assist with bathing",
    question_category: preferences,
    custom: false
  },
  {
    title: "Depression",
    body: "Can you comfort someone depressed?",
    statement: "who can assist with depression",
    question_category: preferences,
    custom: false
  },
  {
    title: "Cooking",
    body: "Can you cook meals?",
    statement: "who can cook meals",
    question_category: preferences,
    custom: false
  },
  {
    title: "Dressing, Shaving, & Grooming",
    body: "Can you assist with dressing, shaving, and grooming?",
    statement: "who can assist with dressing, shaving, and grooming",
    question_category: preferences,
    custom: false
  },
  {
    title: "Meal Prep & Eating",
    body: "Can you assist with preparing meals and eating?",
    statement: "who can assist with preparing meals and eating",
    question_category: preferences,
    custom: false
  },
  {
    title: "Toileting/Continence",
    body: "Can you assist with toileting and continence?",
    statement: "who can assist with toileting and continence",
    question_category: preferences,
    custom: false
  },
  {
    title: "Wound Care",
    body: "Can you assist with wound care?",
    statement: "who can assist with wound care",
    question_category: preferences,
    custom: false
  },
  {
    title: "Dementia",
    body: "Do you have experience with dementia?",
    statement: "who has experience with dementia",
    question_category: experience,
    custom: false
  },
  {
    title: "Hospice",
    body: "Do you have experience with hospice?",
    statement: "who has experience with hospice",
    question_category: experience,
    custom: false
  },
  {
    title: "Parkinson's",
    body: "Do you have experience with Parkinson's?",
    statement: "who has experience with Parkinson's",
    question_category: experience,
    custom: false
  },
  {
    title: "Laundry",
    body: "Can you assist with laundry?",
    statement: "who can assist with laundry",
    question_category: preferences,
    custom: false
  },
  {
    title: "Light Housekeeping",
    body: "Can you assist with light housekeeping?",
    statement: "who can assist with light housekeeping",
    question_category: preferences,
    custom: false
  },
  {
    title: "Medication Reminders & Prep",
    body: "Can you assist with medication reminders and prep?",
    statement: "who can assist with medication reminders and prep",
    question_category: preferences,
    custom: false
  },
  {
    title: "Shopping & Errands",
    body: "Can you assist with shopping and errands?",
    statement: "who can assist with shopping and errands",
    question_category: preferences,
    custom: false
  },
  {
    title: "Can Transport Client by Automobile",
    body: "Can you assist with transporting clients by automobile?",
    statement: "who can assist with transporting clients by automobile",
    question_category: transportation,
    custom: false
  },
  {
    title: "Has Insured Automobile",
    body: "Do you have an insured automobile?",
    statement: "who has an insured automobile",
    question_category: transportation,
    custom: false
  },
  {
    title: "Ok with smoking",
    body: "Is it ok if your client smokes?",
    statement: "who is ok with clients smoking",
    question_category: preferences,
    custom: false
  },
  {
    title: "Live-in Shifts",
    body: "Are you ok working live-in shifts?",
    statement: "who is ok working live-in shifts",
    question_category: schedule,
    custom: false
  },
  {
    title: "Night Shifts",
    body: "Are you ok working night shifts?",
    statement: "who is ok working night shifts",
    question_category: schedule,
    custom: false
  },
  {
    title: "Transfers",
    body: "Do you have experience with transfers in/out of wheelchairs and/or beds?",
    statement: "who has experience with wheelchair and/or bed transfers",
    question_category: experience,
    custom: false
  },
  {
    title: "Gait Belt",
    body: "Do you have experience with a gait belt?",
    statement: "who has experience with gait belts",
    question_category: experience,
    custom: false
  },
  {
    title: "Hoyer Lift",
    body: "Do you have experience with a hoyer lift?",
    statement: "who has experience with a hoyer lift",
    question_category: experience,
    custom: false
  },
  {
    title: "Ok with cats",
    body: "Are you ok with cats?",
    statement: "who is ok with cats",
    question_category: preferences,
    custom: false
  },
  {
    title: "Ok with dogs",
    body: "Are you ok with dogs?",
    statement: "who is ok with dogs",
    question_category: preferences,
    custom: false
  },
  {
    title: "Chest X-Ray",
    body: "Do you have a current chest x-ray?",
    statement: "who has a current chest x-ray",
    question_category: credentials,
    custom: false
  },
  {
    title: "CNA License",
    body: "Do you have a current CNA license?",
    statement: "who has a current CNA license",
    question_category: credentials,
    custom: false
  },
  {
    title: "Driver's License",
    body: "Do you have a current driver's license?",
    statement: "who has a current driver's license",
    question_category: credentials,
    custom: false
  },
  {
    title: "First Aid Certification",
    body: "Do you have a current first aid certification?",
    statement: "who has a current first aid certification",
    question_category: credentials,
    custom: false
  },
  {
    title: "CPR Certification",
    body: "Do you have a current CPR certification?",
    statement: "who has a current CPR certification",
    question_category: credentials,
    custom: false
  },
  {
    title: "HHA Certification",
    body: "Do you have a current HHA certification?",
    statement: "who has a current HHA certification",
    question_category: credentials,
    custom: false
  },
  {
    title: "Registered Nurse",
    body: "Are you a current registered nurse?",
    statement: "who is a current registered nurse",
    question_category: credentials,
    custom: false
  },
  {
    title: "Tuberculosis Test",
    body: "Do you have a current Tuberculosis test?",
    statement: "who has a current Tuberculosis test",
    question_category: credentials,
    custom: false
  },
  {
    title: "LVN/LPN Certification",
    body: "Do you have a current LVN/LPN certification?",
    statement: "who has a current LVN/LPN certification",
    question_category: credentials,
    custom: false
  },
  {
    title: "7am - 3pm",
    body: "Can you work 7am - 3pm?",
    statement: "who can work 7am - 3pm",
    question_category: schedule,
    custom: false
  },
  {
    title: "3pm - 11pm",
    body: "Can you work 3pm - 11pm?",
    statement: "who can work 3pm - 11pm",
    question_category: schedule,
    custom: false
  },
  {
    title: "11pm - 7am",
    body: "Can you work 11pm - 7am?",
    statement: "who can work 11pm - 7am",
    question_category: schedule,
    custom: false
  },
  {
    title: "MWF",
    body: "Can you work Monday, Wednesday, and Friday?",
    statement: "who can work Monday, Wednesday, and Friday",
    question_category: schedule,
    custom: false
  },
  {
    title: "TTh",
    body: "Can you work Tuesday and Thursday?",
    statement: "who can work Tuesday and Thursday",
    question_category: schedule,
    custom: false
  },
  {
    title: "Saturday",
    body: "Can you work Saturdays?",
    statement: "who can work Saturdays",
    question_category: schedule,
    custom: false
  },
  {
    title: "Sunday",
    body: "Can you work Sundays?",
    statement: "who can work Sundays",
    question_category: schedule,
    custom: false
  },
  {
    title: "Monday",
    body: "Can you work Mondays?",
    statement: "who can work Mondays",
    question_category: schedule,
    custom: false
  },
  {
    title: "Tuesday",
    body: "Can you work Tuesdays?",
    statement: "who can work Tuesdays",
    question_category: schedule,
    custom: false
  },
  {
    title: "Wednesday",
    body: "Can you work Wednesdays?",
    statement: "who can work Wednesdays",
    question_category: schedule,
    custom: false
  },
  {
    title: "Thursday",
    body: "Can you work Thursdays?",
    statement: "who can work Thursdays",
    question_category: schedule,
    custom: false
  },
  {
    title: "Friday",
    body: "Can you work Fridays?",
    statement: "who can work Fridays",
    question_category: schedule,
    custom: false
  }
]

Question.create(questions) unless Question.exists?

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
  Account.create(password: "password", password_confirmation: "password", role: Account.roles[:owner], user: user, organization: org, email: email, super_admin: true)
end

Phone.find_or_create_by(title: "#{org.name} Referrals", number: "+16788417816", organization: org)

Referrer.find_or_create_by(user: user, organization: org)

lead = Lead.find_or_create_by(organization: org, user: user)

lead.subscribe unless lead.subscribed?
