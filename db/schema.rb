# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160604160317) do

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "super_admin",            default: false, null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true, using: :btree
  add_index "accounts", ["invitations_count"], name: "index_accounts_on_invitations_count", using: :btree
  add_index "accounts", ["invited_by_id"], name: "index_accounts_on_invited_by_id", using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "inquiry_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "answers", ["inquiry_id"], name: "index_answers_on_inquiry_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "candidate_features", force: :cascade do |t|
    t.integer  "candidate_id",                  null: false
    t.integer  "ideal_feature_id",              null: false
    t.jsonb    "properties",       default: {}, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "candidate_features", ["candidate_id"], name: "index_candidate_features_on_candidate_id", using: :btree
  add_index "candidate_features", ["ideal_feature_id"], name: "index_candidate_features_on_ideal_feature_id", using: :btree
  add_index "candidate_features", ["properties"], name: "index_candidate_features_on_properties", using: :gin

  create_table "candidates", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.string   "status",           default: "Potential", null: false
    t.boolean  "screened",         default: false,       null: false
    t.boolean  "subscribed",       default: false,       null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "ideal_profile_id",                       null: false
  end

  add_index "candidates", ["ideal_profile_id"], name: "index_candidates_on_ideal_profile_id", using: :btree
  add_index "candidates", ["user_id"], name: "index_candidates_on_user_id", using: :btree

  create_table "chirps", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "chirps", ["user_id"], name: "index_chirps_on_user_id", using: :btree

  create_table "ideal_features", force: :cascade do |t|
    t.integer  "ideal_profile_id", null: false
    t.string   "format",           null: false
    t.string   "name",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "ideal_features", ["ideal_profile_id"], name: "index_ideal_features_on_ideal_profile_id", using: :btree

  create_table "ideal_profiles", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "ideal_profiles", ["organization_id"], name: "index_ideal_profiles_on_organization_id", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "candidate_feature_id", null: false
  end

  add_index "inquiries", ["candidate_feature_id"], name: "index_inquiries_on_candidate_feature_id", using: :btree
  add_index "inquiries", ["user_id"], name: "index_inquiries_on_user_id", using: :btree

  create_table "media_instances", force: :cascade do |t|
    t.string   "sid",          null: false
    t.string   "content_type", null: false
    t.text     "uri",          null: false
    t.integer  "message_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "media_instances", ["message_id"], name: "index_media_instances_on_message_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "sid",              null: false
    t.text     "body"
    t.string   "direction",        null: false
    t.integer  "messageable_id",   null: false
    t.string   "messageable_type", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "messages", ["messageable_type", "messageable_id"], name: "index_messages_on_messageable_type_and_messageable_id", using: :btree
  add_index "messages", ["sid"], name: "index_messages_on_sid", unique: true, using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "template_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "notifications", ["template_id"], name: "index_notifications_on_template_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                                                      null: false
    t.string   "twilio_account_sid"
    t.string   "twilio_auth_token"
    t.string   "phone_number"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "time_zone",          default: "Eastern Time (US & Canada)", null: false
  end

  add_index "organizations", ["phone_number"], name: "index_organizations_on_phone_number", unique: true, using: :btree

  create_table "referrals", force: :cascade do |t|
    t.integer  "candidate_id", null: false
    t.integer  "referrer_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "referrals", ["candidate_id"], name: "index_referrals_on_candidate_id", using: :btree
  add_index "referrals", ["referrer_id"], name: "index_referrals_on_referrer_id", using: :btree

  create_table "referrers", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "referrers", ["user_id"], name: "index_referrers_on_user_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.integer  "organization_id",                null: false
    t.string   "trigger",                        null: false
    t.integer  "action_id"
    t.string   "action_type"
    t.boolean  "enabled",         default: true, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "rules", ["action_type", "action_id"], name: "index_rules_on_action_type_and_action_id", using: :btree
  add_index "rules", ["organization_id"], name: "index_rules_on_organization_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "taskable_id",                  null: false
    t.string   "taskable_type",                null: false
    t.boolean  "outstanding",   default: true, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "body",            null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "templates", ["body", "organization_id"], name: "index_templates_on_body_and_organization_id", unique: true, using: :btree
  add_index "templates", ["name", "organization_id"], name: "index_templates_on_name_and_organization_id", unique: true, using: :btree
  add_index "templates", ["organization_id"], name: "index_templates_on_organization_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.boolean  "contact",         default: false, null: false
    t.integer  "organization_id",                 null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["contact", "organization_id"], name: "index_users_on_contact_and_organization_id", unique: true, where: "(contact = true)", using: :btree
  add_index "users", ["organization_id", "phone_number"], name: "index_users_on_organization_id_and_phone_number", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

  add_foreign_key "accounts", "users"
  add_foreign_key "answers", "inquiries"
  add_foreign_key "answers", "users"
  add_foreign_key "candidate_features", "candidates"
  add_foreign_key "candidate_features", "ideal_features"
  add_foreign_key "candidates", "ideal_profiles"
  add_foreign_key "candidates", "users"
  add_foreign_key "chirps", "users"
  add_foreign_key "ideal_features", "ideal_profiles"
  add_foreign_key "ideal_profiles", "organizations"
  add_foreign_key "inquiries", "candidate_features"
  add_foreign_key "inquiries", "users"
  add_foreign_key "media_instances", "messages"
  add_foreign_key "notifications", "templates"
  add_foreign_key "notifications", "users"
  add_foreign_key "referrals", "candidates"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "referrers", "users"
  add_foreign_key "rules", "organizations"
  add_foreign_key "tasks", "users"
  add_foreign_key "templates", "organizations"
  add_foreign_key "users", "organizations"
end
