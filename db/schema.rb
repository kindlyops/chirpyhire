# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170218181324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "super_admin",            default: false, null: false
    t.boolean  "agreed_to_terms",        default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.integer  "organization_id",                        null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id", using: :btree
    t.index ["organization_id"], name: "index_accounts_on_organization_id", using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "inquiry_id",   null: false
    t.integer  "candidacy_id", null: false
    t.integer  "message_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["candidacy_id"], name: "index_answers_on_candidacy_id", using: :btree
    t.index ["inquiry_id"], name: "index_answers_on_inquiry_id", using: :btree
    t.index ["message_id"], name: "index_answers_on_message_id", using: :btree
  end

  create_table "candidacies", force: :cascade do |t|
    t.integer  "experience"
    t.boolean  "skin_test"
    t.integer  "availability"
    t.integer  "transportation"
    t.string   "zip_code"
    t.integer  "cpr_first_aid"
    t.integer  "certification"
    t.integer  "person_id",      null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["person_id"], name: "index_candidacies_on_person_id", using: :btree
  end

  create_table "ideal_candidate_suggestions", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.text     "value",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_ideal_candidate_suggestions_on_organization_id", using: :btree
  end

  create_table "ideal_candidates", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_ideal_candidates_on_organization_id", using: :btree
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer  "candidacy_id", null: false
    t.integer  "message_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["candidacy_id"], name: "index_inquiries_on_candidacy_id", using: :btree
    t.index ["message_id"], name: "index_inquiries_on_message_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.float    "latitude",            null: false
    t.float    "longitude",           null: false
    t.string   "full_street_address", null: false
    t.string   "city",                null: false
    t.string   "state",               null: false
    t.string   "state_code"
    t.string   "postal_code",         null: false
    t.string   "country",             null: false
    t.string   "country_code"
    t.integer  "organization_id",     null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["organization_id"], name: "index_locations_on_organization_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "sid",                 null: false
    t.text     "body"
    t.string   "direction",           null: false
    t.datetime "sent_at",             null: false
    t.datetime "external_created_at", null: false
    t.integer  "organization_id",     null: false
    t.integer  "person_id",           null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["organization_id"], name: "index_messages_on_organization_id", using: :btree
    t.index ["person_id"], name: "index_messages_on_person_id", using: :btree
    t.index ["sid"], name: "index_messages_on_sid", unique: true, using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "zip_code",           null: false
    t.string   "twilio_account_sid"
    t.string   "twilio_auth_token"
    t.string   "phone_number"
    t.string   "stripe_customer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["phone_number"], name: "index_organizations_on_phone_number", unique: true, using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "full_name"
    t.string   "nickname",     null: false
    t.string   "phone_number", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "plans", force: :cascade do |t|
    t.integer  "amount",            null: false
    t.string   "interval",          null: false
    t.string   "name",              null: false
    t.string   "stripe_id",         null: false
    t.integer  "interval_count"
    t.integer  "trial_period_days"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["stripe_id"], name: "index_plans_on_stripe_id", unique: true, using: :btree
  end

  create_table "subscribers", force: :cascade do |t|
    t.integer  "person_id",                      null: false
    t.integer  "organization_id",                null: false
    t.boolean  "subscribed",      default: true, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["organization_id"], name: "index_subscribers_on_organization_id", using: :btree
    t.index ["person_id", "organization_id"], name: "index_subscribers_on_person_id_and_organization_id", unique: true, using: :btree
    t.index ["person_id"], name: "index_subscribers_on_person_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "stripe_customer_id"
    t.float    "application_fee_percent"
    t.boolean  "cancel_at_period_end"
    t.datetime "canceled_at"
    t.datetime "stripe_created_at"
    t.datetime "current_period_end"
    t.datetime "current_period_start"
    t.datetime "ended_at"
    t.integer  "quantity"
    t.datetime "start"
    t.string   "status"
    t.float    "tax_percent"
    t.datetime "trial_end"
    t.datetime "trial_start"
    t.integer  "plan_id",                             null: false
    t.integer  "organization_id",                     null: false
    t.integer  "state",                   default: 0, null: false
    t.integer  "trial_message_limit",     default: 0, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id", using: :btree
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
    t.index ["stripe_id"], name: "index_subscriptions_on_stripe_id", unique: true, using: :btree
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "value",              null: false
    t.integer  "ideal_candidate_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["ideal_candidate_id", "value"], name: "index_zip_codes_on_ideal_candidate_id_and_value", unique: true, using: :btree
    t.index ["ideal_candidate_id"], name: "index_zip_codes_on_ideal_candidate_id", using: :btree
  end

  add_foreign_key "accounts", "organizations"
  add_foreign_key "answers", "candidacies"
  add_foreign_key "answers", "inquiries"
  add_foreign_key "answers", "messages"
  add_foreign_key "candidacies", "people"
  add_foreign_key "ideal_candidate_suggestions", "organizations"
  add_foreign_key "ideal_candidates", "organizations"
  add_foreign_key "inquiries", "candidacies"
  add_foreign_key "inquiries", "messages"
  add_foreign_key "locations", "organizations"
  add_foreign_key "messages", "organizations"
  add_foreign_key "messages", "people"
  add_foreign_key "subscribers", "organizations"
  add_foreign_key "subscribers", "people"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "zip_codes", "ideal_candidates"
end
