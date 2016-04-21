# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

FactoryGirl.create(:account, role: Account.roles[:owner], user: user, organization: org, email: "harrywhelchel@gmail.com", super_admin: true)

Phone.find_or_create_by(title: "#{org.name} Referrals", number: "+16788417816", organization: org)

Referrer.find_or_create_by(user: user, organization: org)

questions = [
  {
    label: "Bathing",
    body: "Can you assist someone with bathing?",
    statement: "who can assist with bathing",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Depression",
    body: "Can you comfort someone depressed?",
    statement: "who can assist with depression",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Cooking",
    body: "Can you cook meals?",
    statement: "who can cook meals",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Dressing, Shaving, & Grooming",
    body: "Can you assist with dressing, shaving, and grooming?",
    statement: "who can assist with dressing, shaving, and grooming",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Meal Prep & Eating",
    body: "Can you assist with preparing meals and eating?",
    statement: "who can assist with preparing meals and eating",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Toileting/Continence",
    body: "Can you assist with toileting and continence?",
    statement: "who can assist with toileting and continence",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Wound Care",
    body: "Can you assist with wound care?",
    statement: "who can assist with wound care",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Dementia",
    body: "Do you have experience with dementia?",
    statement: "who has experience with dementia",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Hospice",
    body: "Do you have experience with hospice?",
    statement: "who has experience with hospice",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Parkinson's",
    body: "Do you have experience with Parkinson's?",
    statement: "who has experience with Parkinson's",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Laundry",
    body: "Can you assist with laundry?",
    statement: "who can assist with laundry",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Light Housekeeping",
    body: "Can you assist with light housekeeping?",
    statement: "who can assist with light housekeeping",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Medication Reminders & Prep",
    body: "Can you assist with medication reminders and prep?",
    statement: "who can assist with medication reminders and prep",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Shopping & Errands",
    body: "Can you assist with shopping and errands?",
    statement: "who can assist with shopping and errands",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Transporting Client by Automobile",
    body: "Can you assist with transporting clients by automobile?",
    statement: "who can assist with transporting clients by automobile",
    category: Question.categories[:transportation],
    custom: false
  },
  {
    label: "Has Insured Automobile",
    body: "Do you have an insured automobile?",
    statement: "who has an insured automobile",
    category: Question.categories[:transportation],
    custom: false
  },
  {
    label: "Ok with Smoking",
    body: "Is it ok if your client smokes?",
    statement: "who is ok with clients smoking",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Live-in Shifts",
    body: "Are you ok working live-in shifts?",
    statement: "who is ok working live-in shifts",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Night Shifts",
    body: "Are you ok working night shifts?",
    statement: "who is ok working night shifts",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Transfers",
    body: "Do you have experience with transfers in/out of wheelchairs and/or beds?",
    statement: "who has experience with wheelchair and/or bed transfers",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Gait Belt",
    body: "Do you have experience with a gait belt?",
    statement: "who has experience with gait belts",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Hoyer Lift",
    body: "Do you have experience with a hoyer lift?",
    statement: "who has experience with a hoyer lift",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Ok with cats",
    body: "Are you ok with cats?",
    statement: "who is ok with cats",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Ok with dogs",
    body: "Are you ok with dogs?",
    statement: "who is ok with dogs",
    category: Question.categories[:preference],
    custom: false
  },
  {
    label: "Alzheimer's",
    body: "Do you have experience with Alzheimer's?",
    statement: "who has experience with Alzheimer's",
    category: Question.categories[:experience],
    custom: false
  },
  {
    label: "Chest X-Ray",
    body: "Do you have a current chest x-ray?",
    statement: "who has a current chest x-ray",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "CNA License",
    body: "Do you have a current CNA license?",
    statement: "who has a current CNA license",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "Driver's License",
    body: "Do you have a current driver's license?",
    statement: "who has a current driver's license",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "First Aid Certification",
    body: "Do you have a current first aid certification?",
    statement: "who has a current first aid certification",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "CPR Certification",
    body: "Do you have a current CPR certification?",
    statement: "who has a current CPR certification",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "HHA Certification",
    body: "Do you have a current HHA certification?",
    statement: "who has a current HHA certification",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "Registered Nurse",
    body: "Are you a current registered nurse?",
    statement: "who is a current registered nurse",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "Tuberculosis Test",
    body: "Do you have a current Tuberculosis test?",
    statement: "who has a current Tuberculosis test",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "LVN/LPN Certification",
    body: "Do you have a current LVN/LPN certification?",
    statement: "who has a current LVN/LPN certification",
    category: Question.categories[:credentials],
    custom: false
  },
  {
    label: "7am - 3pm",
    body: "Can you work 7am - 3pm?",
    statement: "who can work 7am - 3pm",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "3pm - 11pm",
    body: "Can you work 3pm - 11pm?",
    statement: "who can work 3pm - 11pm",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "11pm - 7am",
    body: "Can you work 11pm - 7am?",
    statement: "who can work 11pm - 7am",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "MWF",
    body: "Can you work Monday, Wednesday, and Friday?",
    statement: "who can work Monday, Wednesday, and Friday",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "TTh",
    body: "Can you work Tuesday and Thursday?",
    statement: "who can work Tuesday and Thursday",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Saturday",
    body: "Can you work Saturdays?",
    statement: "who can work Saturdays",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Sunday",
    body: "Can you work Sundays?",
    statement: "who can work Sundays",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Monday",
    body: "Can you work Mondays?",
    statement: "who can work Mondays",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Tuesday",
    body: "Can you work Tuesdays?",
    statement: "who can work Tuesdays",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Wednesday",
    body: "Can you work Wednesdays?",
    statement: "who can work Wednesdays",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Thursday",
    body: "Can you work Thursdays?",
    statement: "who can work Thursdays",
    category: Question.categories[:schedule],
    custom: false
  },
  {
    label: "Friday",
    body: "Can you work Fridays?",
    statement: "who can work Fridays",
    category: Question.categories[:schedule],
    custom: false
  }
]

org.questions.create(questions) unless org.questions.exists?

Lead.find_or_create_by(organization: org, user: user)
