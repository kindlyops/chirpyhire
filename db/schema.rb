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

ActiveRecord::Schema.define(version: 20160907091711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id"
    t.boolean  "super_admin",            default: false, null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.boolean  "agreed_to_terms",        default: false, null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id", using: :btree
    t.index ["invited_by_type", "invited_by_id"], name: "index_accounts_on_invited_by_type_and_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "actionables", force: :cascade do |t|
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_actionables_on_type", using: :btree
  end

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters"
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.jsonb    "properties"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["properties"], name: "index_activities_on_properties", using: :gin
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "address_question_options", force: :cascade do |t|
    t.integer  "distance",    null: false
    t.float    "latitude",    null: false
    t.float    "longitude",   null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_address_question_options_on_question_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "inquiry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "message_id", null: false
    t.index ["inquiry_id"], name: "index_answers_on_inquiry_id", using: :btree
    t.index ["message_id"], name: "index_answers_on_message_id", using: :btree
  end

  create_table "candidate_features", force: :cascade do |t|
    t.integer  "candidate_id",                null: false
    t.jsonb    "properties",   default: "{}", null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "label",                       null: false
    t.index ["candidate_id"], name: "index_candidate_features_on_candidate_id", using: :btree
    t.index ["properties"], name: "index_candidate_features_on_properties", using: :gin
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.string   "status",     default: "Potential", null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["user_id"], name: "index_candidates_on_user_id", using: :btree
  end

  create_table "choice_question_options", force: :cascade do |t|
    t.string   "letter",      null: false
    t.string   "text",        null: false
    t.integer  "question_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["letter", "question_id"], name: "index_choice_question_options_on_letter_and_question_id", unique: true, using: :btree
    t.index ["question_id"], name: "index_choice_question_options_on_question_id", using: :btree
    t.index ["text", "question_id"], name: "index_choice_question_options_on_text_and_question_id", unique: true, using: :btree
  end

  create_table "inquiries", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "message_id",  null: false
    t.integer  "question_id", null: false
    t.index ["message_id"], name: "index_inquiries_on_message_id", using: :btree
    t.index ["question_id"], name: "index_inquiries_on_question_id", using: :btree
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

  create_table "media_instances", force: :cascade do |t|
    t.string   "sid",          null: false
    t.string   "content_type", null: false
    t.text     "uri",          null: false
    t.integer  "message_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["message_id"], name: "index_media_instances_on_message_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "sid",                 null: false
    t.text     "body"
    t.string   "direction",           null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id",             null: false
    t.datetime "sent_at"
    t.datetime "external_created_at"
    t.integer  "child_id"
    t.index ["child_id"], name: "index_messages_on_child_id", unique: true, using: :btree
    t.index ["sid"], name: "index_messages_on_sid", unique: true, using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "template_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "message_id",  null: false
    t.index ["message_id"], name: "index_notifications_on_message_id", using: :btree
    t.index ["template_id"], name: "index_notifications_on_template_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                                                      null: false
    t.string   "twilio_account_sid"
    t.string   "twilio_auth_token"
    t.string   "phone_number"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "time_zone",          default: "Eastern Time (US & Canada)", null: false
    t.string   "stripe_customer_id"
    t.string   "stripe_token"
    t.index ["phone_number"], name: "index_organizations_on_phone_number", unique: true, using: :btree
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

  create_table "questions", force: :cascade do |t|
    t.integer  "survey_id",              null: false
    t.string   "text",                   null: false
    t.integer  "status",     default: 0, null: false
    t.integer  "priority",               null: false
    t.string   "type",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "label",                  null: false
    t.index ["survey_id"], name: "index_questions_on_survey_id", using: :btree
  end

  create_table "referrals", force: :cascade do |t|
    t.integer  "candidate_id", null: false
    t.integer  "referrer_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["candidate_id"], name: "index_referrals_on_candidate_id", using: :btree
    t.index ["referrer_id"], name: "index_referrals_on_referrer_id", using: :btree
  end

  create_table "referrers", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_referrers_on_user_id", using: :btree
  end

  create_table "rules", force: :cascade do |t|
    t.integer  "organization_id",                null: false
    t.string   "trigger",                        null: false
    t.boolean  "enabled",         default: true, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "actionable_id",                  null: false
    t.index ["actionable_id"], name: "index_rules_on_actionable_id", using: :btree
    t.index ["organization_id"], name: "index_rules_on_organization_id", using: :btree
  end

  create_table "stages", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id", "order"], name: "index_stages_on_organization_id_and_order", unique: true, using: :btree
    t.index ["organization_id"], name: "index_stages_on_organization_id", using: :btree
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "trial_message_limit",     default: 0, null: false
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id", using: :btree
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
    t.index ["stripe_id"], name: "index_subscriptions_on_stripe_id", unique: true, using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.integer  "actionable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "welcome_id",      null: false
    t.integer  "thank_you_id",    null: false
    t.integer  "bad_fit_id",      null: false
    t.index ["actionable_id"], name: "index_surveys_on_actionable_id", using: :btree
    t.index ["bad_fit_id"], name: "index_surveys_on_bad_fit_id", using: :btree
    t.index ["organization_id"], name: "index_surveys_on_organization_id", unique: true, using: :btree
    t.index ["thank_you_id"], name: "index_surveys_on_thank_you_id", using: :btree
    t.index ["welcome_id"], name: "index_surveys_on_welcome_id", using: :btree
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "body",            null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "actionable_id"
    t.index ["actionable_id"], name: "index_templates_on_actionable_id", using: :btree
    t.index ["body", "organization_id"], name: "index_templates_on_body_and_organization_id", unique: true, using: :btree
    t.index ["name", "organization_id"], name: "index_templates_on_name_and_organization_id", unique: true, using: :btree
    t.index ["organization_id"], name: "index_templates_on_organization_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.integer  "organization_id",                     null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "subscribed",          default: false, null: false
    t.boolean  "has_unread_messages", default: false, null: false
    t.index ["organization_id", "phone_number"], name: "index_users_on_organization_id_and_phone_number", unique: true, using: :btree
    t.index ["organization_id"], name: "index_users_on_organization_id", using: :btree
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
    t.index ["version_id"], name: "index_version_associations_on_version_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
    t.index ["object"], name: "index_versions_on_object", using: :gin
    t.index ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "address_question_options", "questions"
  add_foreign_key "answers", "inquiries"
  add_foreign_key "answers", "messages"
  add_foreign_key "candidate_features", "candidates"
  add_foreign_key "candidates", "users"
  add_foreign_key "choice_question_options", "questions"
  add_foreign_key "inquiries", "messages"
  add_foreign_key "inquiries", "questions"
  add_foreign_key "locations", "organizations"
  add_foreign_key "media_instances", "messages"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "messages"
  add_foreign_key "notifications", "templates"
  add_foreign_key "questions", "surveys"
  add_foreign_key "referrals", "candidates"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "referrers", "users"
  add_foreign_key "rules", "actionables"
  add_foreign_key "rules", "organizations"
  add_foreign_key "stages", "organizations"
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "surveys", "actionables"
  add_foreign_key "surveys", "organizations"
  add_foreign_key "surveys", "templates", column: "bad_fit_id"
  add_foreign_key "surveys", "templates", column: "thank_you_id"
  add_foreign_key "surveys", "templates", column: "welcome_id"
  add_foreign_key "templates", "actionables"
  add_foreign_key "templates", "organizations"
  add_foreign_key "users", "organizations"
end
