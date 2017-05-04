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

ActiveRecord::Schema.define(version: 20170504235307) do

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
    t.integer  "person_id",                              null: false
    t.integer  "unread_count",           default: 0,     null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id", using: :btree
    t.index ["organization_id"], name: "index_accounts_on_organization_id", using: :btree
    t.index ["person_id"], name: "index_accounts_on_person_id", using: :btree
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.text     "content"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.index ["token"], name: "index_ahoy_messages_on_token", using: :btree
    t.index ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree
  end

  create_table "candidacies", force: :cascade do |t|
    t.integer  "experience"
    t.boolean  "skin_test"
    t.integer  "availability"
    t.integer  "transportation"
    t.string   "zipcode"
    t.boolean  "cpr_first_aid"
    t.integer  "certification"
    t.integer  "person_id",                  null: false
    t.integer  "inquiry"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "contact_id"
    t.integer  "state",          default: 0, null: false
    t.index ["person_id"], name: "index_candidacies_on_person_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "person_id",                       null: false
    t.integer  "organization_id",                 null: false
    t.boolean  "subscribed",      default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "candidate",       default: false, null: false
    t.datetime "last_reply_at"
    t.index ["organization_id"], name: "index_contacts_on_organization_id", using: :btree
    t.index ["person_id", "organization_id"], name: "index_contacts_on_person_id_and_organization_id", unique: true, using: :btree
    t.index ["person_id"], name: "index_contacts_on_person_id", using: :btree
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "contact_id",                 null: false
    t.integer  "account_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "unread_count",   default: 0, null: false
    t.datetime "last_viewed_at"
    t.index ["account_id"], name: "index_conversations_on_account_id", using: :btree
    t.index ["contact_id", "account_id"], name: "index_conversations_on_contact_id_and_account_id", unique: true, using: :btree
    t.index ["contact_id"], name: "index_conversations_on_contact_id", using: :btree
  end

  create_table "ideal_candidate_suggestions", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.text     "value",           null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_ideal_candidate_suggestions_on_organization_id", using: :btree
  end

  create_table "ideal_candidate_zipcodes", force: :cascade do |t|
    t.string   "value",              null: false
    t.integer  "ideal_candidate_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["ideal_candidate_id", "value"], name: "index_ideal_candidate_zipcodes_on_ideal_candidate_id_and_value", unique: true, using: :btree
    t.index ["ideal_candidate_id"], name: "index_ideal_candidate_zipcodes_on_ideal_candidate_id", using: :btree
  end

  create_table "ideal_candidates", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_ideal_candidates_on_organization_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.float    "latitude",            null: false
    t.float    "longitude",           null: false
    t.string   "full_street_address", null: false
    t.string   "city",                null: false
    t.string   "state",               null: false
    t.string   "state_code",          null: false
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
    t.datetime "sent_at"
    t.datetime "external_created_at"
    t.integer  "organization_id",     null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "sender_id",           null: false
    t.integer  "recipient_id"
    t.index ["organization_id"], name: "index_messages_on_organization_id", using: :btree
    t.index ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_messages_on_sender_id", using: :btree
    t.index ["sid"], name: "index_messages_on_sid", unique: true, using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.string   "body",       null: false
    t.integer  "contact_id", null: false
    t.integer  "account_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_notes_on_account_id", using: :btree
    t.index ["contact_id"], name: "index_notes_on_contact_id", using: :btree
    t.index ["deleted_at"], name: "index_notes_on_deleted_at", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                null: false
    t.string   "twilio_account_sid"
    t.string   "twilio_auth_token"
    t.string   "phone_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "recruiter_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["phone_number"], name: "index_organizations_on_phone_number", unique: true, using: :btree
    t.index ["recruiter_id"], name: "index_organizations_on_recruiter_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "phone_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "zipcode_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["phone_number"], name: "index_people_on_phone_number", unique: true, using: :btree
    t.index ["zipcode_id"], name: "index_people_on_zipcode_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.integer  "organization_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_pg_search_documents_on_organization_id", using: :btree
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "read_receipts", force: :cascade do |t|
    t.integer  "conversation_id", null: false
    t.integer  "message_id",      null: false
    t.datetime "read_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id", "message_id"], name: "index_read_receipts_on_conversation_id_and_message_id", unique: true, using: :btree
    t.index ["conversation_id"], name: "index_read_receipts_on_conversation_id", using: :btree
    t.index ["message_id"], name: "index_read_receipts_on_message_id", using: :btree
  end

  create_table "recruiting_ads", force: :cascade do |t|
    t.integer  "organization_id", null: false
    t.text     "body",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_recruiting_ads_on_organization_id", using: :btree
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "zipcode",            null: false
    t.string "zipcode_type",       null: false
    t.string "default_city",       null: false
    t.string "county_fips",        null: false
    t.string "county_name",        null: false
    t.string "state_abbreviation", null: false
    t.string "state",              null: false
    t.float  "latitude",           null: false
    t.float  "longitude",          null: false
    t.string "precision",          null: false
    t.index ["zipcode"], name: "index_zipcodes_on_zipcode", unique: true, using: :btree
  end

  add_foreign_key "accounts", "organizations"
  add_foreign_key "accounts", "people"
  add_foreign_key "candidacies", "people"
  add_foreign_key "contacts", "organizations"
  add_foreign_key "contacts", "people"
  add_foreign_key "conversations", "accounts"
  add_foreign_key "conversations", "contacts"
  add_foreign_key "ideal_candidate_suggestions", "organizations"
  add_foreign_key "ideal_candidate_zipcodes", "ideal_candidates"
  add_foreign_key "ideal_candidates", "organizations"
  add_foreign_key "locations", "organizations"
  add_foreign_key "messages", "organizations"
  add_foreign_key "messages", "people", column: "recipient_id"
  add_foreign_key "messages", "people", column: "sender_id"
  add_foreign_key "notes", "accounts"
  add_foreign_key "notes", "contacts"
  add_foreign_key "organizations", "accounts", column: "recruiter_id"
  add_foreign_key "people", "zipcodes"
  add_foreign_key "pg_search_documents", "organizations"
  add_foreign_key "read_receipts", "conversations"
  add_foreign_key "read_receipts", "messages"
  add_foreign_key "recruiting_ads", "organizations"
end
