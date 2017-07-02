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

ActiveRecord::Schema.define(version: 20170702032841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "super_admin", default: false, null: false
    t.boolean "agreed_to_terms", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "organization_id", null: false
    t.integer "role", default: 0, null: false
    t.text "bio"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count"
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id"
    t.index ["organization_id"], name: "index_accounts_on_organization_id"
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "ahoy_messages", id: :serial, force: :cascade do |t|
    t.string "token"
    t.text "to"
    t.integer "user_id"
    t.string "user_type"
    t.string "mailer"
    t.text "subject"
    t.text "content"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.index ["token"], name: "index_ahoy_messages_on_token"
    t.index ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type"
  end

  create_table "assignment_rules", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "inbox_id", null: false
    t.bigint "phone_number_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inbox_id"], name: "index_assignment_rules_on_inbox_id"
    t.index ["organization_id", "phone_number_id", "inbox_id"], name: "unique_assignment_rules", unique: true
    t.index ["organization_id"], name: "index_assignment_rules_on_organization_id"
    t.index ["phone_number_id"], name: "index_assignment_rules_on_phone_number_id"
  end

  create_table "bot_campaigns", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.bigint "inbox_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id", "campaign_id"], name: "index_bot_campaigns_on_bot_id_and_campaign_id", unique: true
    t.index ["bot_id"], name: "index_bot_campaigns_on_bot_id"
    t.index ["campaign_id"], name: "index_bot_campaigns_on_campaign_id"
    t.index ["inbox_id"], name: "index_bot_campaigns_on_inbox_id"
  end

  create_table "bots", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.datetime "last_edited_at"
    t.integer "last_edited_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_edited_by_id"], name: "index_bots_on_last_edited_by_id"
    t.index ["name", "organization_id"], name: "index_bots_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_bots_on_organization_id"
  end

  create_table "campaign_conversations", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "conversation_id", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "conversation_id"], name: "index_campaign_conversations_on_campaign_id_and_conversation_id", unique: true
    t.index ["campaign_id"], name: "index_campaign_conversations_on_campaign_id"
    t.index ["conversation_id", "state"], name: "index_campaign_conversations_on_conversation_id_and_state", unique: true, where: "(state = 0)"
    t.index ["conversation_id"], name: "index_campaign_conversations_on_conversation_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_campaigns_on_name"
  end

  create_table "contact_candidacies", force: :cascade do |t|
    t.integer "experience"
    t.boolean "skin_test"
    t.integer "availability"
    t.integer "transportation"
    t.string "zipcode"
    t.boolean "cpr_first_aid"
    t.integer "certification"
    t.bigint "contact_id", null: false
    t.integer "inquiry"
    t.integer "state", default: 0, null: false
    t.boolean "live_in"
    t.boolean "drivers_license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_candidacies_on_contact_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "organization_id", null: false
    t.boolean "subscribed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_reply_at"
    t.boolean "starred", default: false, null: false
    t.bigint "team_id"
    t.boolean "screened", default: false, null: false
    t.boolean "reached", default: false, null: false
    t.index ["organization_id"], name: "index_contacts_on_organization_id"
    t.index ["person_id", "organization_id"], name: "index_contacts_on_person_id_and_organization_id", unique: true
    t.index ["person_id"], name: "index_contacts_on_person_id"
    t.index ["team_id"], name: "index_contacts_on_team_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.datetime "last_message_created_at"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "inbox_id", null: false
    t.integer "unread_count", default: 0, null: false
    t.bigint "phone_number_id", null: false
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["phone_number_id"], name: "index_conversations_on_phone_number_id"
    t.index ["state", "contact_id", "phone_number_id"], name: "index_conversations_on_state_and_contact_id_and_phone_number_id", unique: true, where: "(state = 0)"
  end

  create_table "follow_ups", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.integer "next_question_id"
    t.bigint "goal_id"
    t.string "response"
    t.string "body", null: false
    t.integer "action", default: 0, null: false
    t.string "type", default: "ChoiceFollowUp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_follow_ups_on_goal_id"
    t.index ["next_question_id"], name: "index_follow_ups_on_next_question_id"
    t.index ["question_id"], name: "index_follow_ups_on_question_id"
  end

  create_table "follow_ups_tags", force: :cascade do |t|
    t.bigint "follow_up_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follow_up_id"], name: "index_follow_ups_tags_on_follow_up_id"
    t.index ["tag_id"], name: "index_follow_ups_tags_on_tag_id"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_goals_on_bot_id"
  end

  create_table "goals_tags", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_goals_tags_on_goal_id"
    t.index ["tag_id"], name: "index_goals_tags_on_tag_id"
  end

  create_table "greetings", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_greetings_on_bot_id"
  end

  create_table "inboxes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unread_count", default: 0, null: false
    t.bigint "team_id", null: false
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "full_street_address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "state_code", null: false
    t.string "postal_code", null: false
    t.string "country", null: false
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.index ["team_id"], name: "index_locations_on_team_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "team_id"], name: "index_memberships_on_account_id_and_team_id", unique: true
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.string "sid", null: false
    t.text "body"
    t.string "direction", null: false
    t.datetime "sent_at"
    t.datetime "external_created_at"
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id", null: false
    t.integer "recipient_id"
    t.bigint "conversation_id", null: false
    t.string "from", null: false
    t.string "to", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["organization_id"], name: "index_messages_on_organization_id"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
    t.index ["sid"], name: "index_messages_on_sid", unique: true
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.string "body", null: false
    t.integer "contact_id", null: false
    t.integer "account_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_notes_on_account_id"
    t.index ["contact_id"], name: "index_notes_on_contact_id"
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "twilio_account_sid"
    t.string "twilio_auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recruiter_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "url"
    t.string "email"
    t.string "billing_email"
    t.string "description"
    t.integer "contacts_count", default: 0, null: false
    t.integer "screened_contacts_count", default: 0, null: false
    t.integer "reached_contacts_count", default: 0, null: false
    t.integer "starred_contacts_count", default: 0, null: false
    t.boolean "certification", default: true, null: false
    t.boolean "availability", default: true, null: false
    t.boolean "live_in", default: true, null: false
    t.boolean "experience", default: true, null: false
    t.boolean "transportation", default: true, null: false
    t.boolean "drivers_license", default: false, null: false
    t.boolean "zipcode", default: true, null: false
    t.boolean "cpr_first_aid", default: true, null: false
    t.boolean "skin_test", default: true, null: false
    t.string "stripe_customer_id"
    t.index ["recruiter_id"], name: "index_organizations_on_recruiter_id"
  end

  create_table "payment_cards", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "stripe_id", null: false
    t.string "brand", null: false
    t.integer "exp_month", null: false
    t.integer "exp_year", null: false
    t.integer "last4", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_payment_cards_on_organization_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zipcode_id"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "account_id"
    t.index ["account_id"], name: "index_people_on_account_id", unique: true
    t.index ["phone_number"], name: "index_people_on_phone_number", unique: true
    t.index ["zipcode_id"], name: "index_people_on_zipcode_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "sid", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_phone_numbers_on_organization_id"
    t.index ["phone_number"], name: "index_phone_numbers_on_phone_number", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.text "body", null: false
    t.integer "rank", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_questions_on_bot_id"
    t.index ["rank", "bot_id"], name: "index_questions_on_rank_and_bot_id", unique: true
  end

  create_table "read_receipts", id: :serial, force: :cascade do |t|
    t.integer "message_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "conversation_id", null: false
    t.index ["message_id"], name: "index_read_receipts_on_message_id"
  end

  create_table "recruiting_ads", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.index ["organization_id"], name: "index_recruiting_ads_on_organization_id"
    t.index ["team_id"], name: "index_recruiting_ads_on_team_id"
  end

  create_table "segments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.jsonb "form", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_segments_on_account_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id", "tag_id"], name: "index_taggings_on_contact_id_and_tag_id", unique: true
    t.index ["contact_id"], name: "index_taggings_on_contact_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "name"], name: "index_tags_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_tags_on_organization_id"
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.integer "recruiter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "description"
    t.index ["name", "organization_id"], name: "index_teams_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_teams_on_organization_id"
    t.index ["recruiter_id"], name: "index_teams_on_recruiter_id"
  end

  create_table "zipcodes", id: :serial, force: :cascade do |t|
    t.string "zipcode", null: false
    t.string "zipcode_type", null: false
    t.string "default_city", null: false
    t.string "county_fips", null: false
    t.string "county_name", null: false
    t.string "state_abbreviation", null: false
    t.string "state", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "precision", null: false
    t.index ["zipcode"], name: "index_zipcodes_on_zipcode", unique: true
  end

  add_foreign_key "accounts", "organizations"
  add_foreign_key "assignment_rules", "inboxes"
  add_foreign_key "assignment_rules", "organizations"
  add_foreign_key "assignment_rules", "phone_numbers"
  add_foreign_key "bot_campaigns", "bots"
  add_foreign_key "bot_campaigns", "campaigns"
  add_foreign_key "bot_campaigns", "inboxes"
  add_foreign_key "bots", "accounts", column: "last_edited_by_id"
  add_foreign_key "bots", "organizations"
  add_foreign_key "campaign_conversations", "campaigns"
  add_foreign_key "campaign_conversations", "conversations"
  add_foreign_key "contact_candidacies", "contacts"
  add_foreign_key "contacts", "organizations"
  add_foreign_key "contacts", "people"
  add_foreign_key "contacts", "teams"
  add_foreign_key "conversations", "contacts"
  add_foreign_key "conversations", "phone_numbers"
  add_foreign_key "follow_ups", "goals"
  add_foreign_key "follow_ups", "questions"
  add_foreign_key "follow_ups", "questions", column: "next_question_id"
  add_foreign_key "follow_ups_tags", "follow_ups"
  add_foreign_key "follow_ups_tags", "tags"
  add_foreign_key "goals", "bots"
  add_foreign_key "goals_tags", "goals"
  add_foreign_key "goals_tags", "tags"
  add_foreign_key "greetings", "bots"
  add_foreign_key "locations", "teams"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "teams"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "organizations"
  add_foreign_key "messages", "people", column: "recipient_id"
  add_foreign_key "messages", "people", column: "sender_id"
  add_foreign_key "notes", "accounts"
  add_foreign_key "notes", "contacts"
  add_foreign_key "organizations", "accounts", column: "recruiter_id"
  add_foreign_key "payment_cards", "organizations"
  add_foreign_key "people", "accounts"
  add_foreign_key "people", "zipcodes"
  add_foreign_key "phone_numbers", "organizations"
  add_foreign_key "questions", "bots"
  add_foreign_key "read_receipts", "messages"
  add_foreign_key "recruiting_ads", "organizations"
  add_foreign_key "recruiting_ads", "teams"
  add_foreign_key "segments", "accounts"
  add_foreign_key "taggings", "contacts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "organizations"
  add_foreign_key "teams", "organizations"
end
