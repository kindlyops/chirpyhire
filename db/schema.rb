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

ActiveRecord::Schema.define(version: 20160730172222) do

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
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "actionables", force: :cascade do |t|
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_actionables_on_type", using: :btree
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
    t.integer  "category_id",                 null: false
    t.index ["candidate_id"], name: "index_candidate_features_on_candidate_id", using: :btree
    t.index ["category_id"], name: "index_candidate_features_on_category_id", using: :btree
    t.index ["properties"], name: "index_candidate_features_on_properties", using: :gin
  end

  create_table "candidate_personas", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "actionable_id"
    t.integer  "template_id"
    t.index ["actionable_id"], name: "index_candidate_personas_on_actionable_id", using: :btree
    t.index ["organization_id"], name: "index_candidate_personas_on_organization_id", unique: true, using: :btree
    t.index ["template_id"], name: "index_candidate_personas_on_template_id", using: :btree
  end

  create_table "candidates", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.string   "status",     default: "Potential", null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["user_id"], name: "index_candidates_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "inquiries", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "message_id",         null: false
    t.integer  "persona_feature_id", null: false
    t.index ["message_id"], name: "index_inquiries_on_message_id", using: :btree
    t.index ["persona_feature_id"], name: "index_inquiries_on_persona_feature_id", using: :btree
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
    t.index ["phone_number"], name: "index_organizations_on_phone_number", unique: true, using: :btree
  end

  create_table "persona_features", force: :cascade do |t|
    t.integer  "candidate_persona_id",                null: false
    t.string   "format",                              null: false
    t.string   "text",                                null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.jsonb    "properties",           default: "{}", null: false
    t.datetime "deleted_at"
    t.integer  "category_id",                         null: false
    t.integer  "priority",                            null: false
    t.index ["candidate_persona_id", "priority"], name: "index_persona_features_on_candidate_persona_id_and_priority", unique: true, using: :btree
    t.index ["candidate_persona_id"], name: "index_persona_features_on_candidate_persona_id", using: :btree
    t.index ["category_id"], name: "index_persona_features_on_category_id", using: :btree
    t.index ["deleted_at"], name: "index_persona_features_on_deleted_at", using: :btree
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

  add_foreign_key "accounts", "users"
  add_foreign_key "answers", "inquiries"
  add_foreign_key "answers", "messages"
  add_foreign_key "candidate_features", "candidates"
  add_foreign_key "candidate_features", "categories"
  add_foreign_key "candidate_personas", "actionables"
  add_foreign_key "candidate_personas", "organizations"
  add_foreign_key "candidate_personas", "templates"
  add_foreign_key "candidates", "users"
  add_foreign_key "inquiries", "messages"
  add_foreign_key "inquiries", "persona_features"
  add_foreign_key "locations", "organizations"
  add_foreign_key "media_instances", "messages"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "messages"
  add_foreign_key "notifications", "templates"
  add_foreign_key "persona_features", "candidate_personas"
  add_foreign_key "persona_features", "categories"
  add_foreign_key "referrals", "candidates"
  add_foreign_key "referrals", "referrers"
  add_foreign_key "referrers", "users"
  add_foreign_key "rules", "actionables"
  add_foreign_key "rules", "organizations"
  add_foreign_key "templates", "actionables"
  add_foreign_key "templates", "organizations"
  add_foreign_key "users", "organizations"
end
