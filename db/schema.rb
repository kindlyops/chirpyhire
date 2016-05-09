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

ActiveRecord::Schema.define(version: 20160509145833) do

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
    t.integer  "role",                   default: 0,     null: false
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

  create_table "answers", force: :cascade do |t|
    t.integer  "inquiry_id", null: false
    t.integer  "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "answers", ["inquiry_id"], name: "index_answers_on_inquiry_id", using: :btree
  add_index "answers", ["message_id"], name: "index_answers_on_message_id", using: :btree

  create_table "automations", force: :cascade do |t|
    t.string   "name",            null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "automations", ["organization_id"], name: "index_automations_on_organization_id", using: :btree

  create_table "candidates", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "candidates", ["user_id"], name: "index_candidates_on_user_id", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.integer  "question_id", null: false
    t.integer  "message_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "inquiries", ["message_id"], name: "index_inquiries_on_message_id", using: :btree
  add_index "inquiries", ["question_id"], name: "index_inquiries_on_question_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "sid",                    null: false
    t.text     "media_url"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",                null: false
    t.integer  "category",   default: 0, null: false
  end

  add_index "messages", ["sid"], name: "index_messages_on_sid", unique: true, using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.integer  "template_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "notices", ["template_id"], name: "index_notices_on_template_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "notice_id",  null: false
    t.integer  "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notifications", ["message_id"], name: "index_notifications_on_message_id", using: :btree
  add_index "notifications", ["notice_id"], name: "index_notifications_on_notice_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                                                      null: false
    t.string   "twilio_account_sid"
    t.string   "twilio_auth_token"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "time_zone",          default: "Eastern Time (US & Canada)", null: false
  end

  create_table "phones", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.string   "number",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "phones", ["organization_id"], name: "index_phones_on_organization_id", unique: true, using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "template_id",             null: false
    t.integer  "response",    default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "questions", ["template_id"], name: "index_questions_on_template_id", using: :btree

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
    t.integer  "automation_id",             null: false
    t.integer  "status",        default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "rules", ["automation_id"], name: "index_rules_on_automation_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "candidate_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "subscriptions", ["candidate_id"], name: "index_subscriptions_on_candidate_id", unique: true, where: "(deleted_at IS NULL)", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "body",            null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "templates", ["organization_id"], name: "index_templates_on_organization_id", using: :btree

  create_table "triggers", force: :cascade do |t|
    t.integer  "rule_id",    null: false
    t.string   "event",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "triggers", ["rule_id"], name: "index_triggers_on_rule_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["organization_id", "phone_number"], name: "index_users_on_organization_id_and_phone_number", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree

  add_foreign_key "accounts", "users"
  add_foreign_key "answers", "inquiries"
  add_foreign_key "answers", "messages"
  add_foreign_key "automations", "organizations"
  add_foreign_key "candidates", "users"
  add_foreign_key "inquiries", "messages"
  add_foreign_key "inquiries", "questions"
  add_foreign_key "messages", "users"
  add_foreign_key "notices", "templates"
  add_foreign_key "notifications", "messages"
  add_foreign_key "notifications", "notices"
  add_foreign_key "phones", "organizations"
  add_foreign_key "questions", "templates"
  add_foreign_key "referrals", "candidates"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "referrers", "users"
  add_foreign_key "rules", "automations"
  add_foreign_key "subscriptions", "candidates"
  add_foreign_key "templates", "organizations"
  add_foreign_key "triggers", "rules"
  add_foreign_key "users", "organizations"
end
