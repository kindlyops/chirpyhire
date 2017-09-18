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

ActiveRecord::Schema.define(version: 20170918170440) do

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
    t.string "phone_number"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "name"
    t.string "nickname"
    t.bigint "person_id"
    t.boolean "daily_email", default: true, null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["invitation_token"], name: "index_accounts_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_accounts_on_invitations_count"
    t.index ["invited_by_id"], name: "index_accounts_on_invited_by_id"
    t.index ["organization_id", "nickname"], name: "index_accounts_on_organization_id_and_nickname", unique: true
    t.index ["organization_id"], name: "index_accounts_on_organization_id"
    t.index ["person_id"], name: "index_accounts_on_person_id"
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

  create_table "bot_actions", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.string "type", null: false
    t.bigint "goal_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["bot_id"], name: "index_bot_actions_on_bot_id"
    t.index ["deleted_at"], name: "index_bot_actions_on_deleted_at"
    t.index ["goal_id"], name: "index_bot_actions_on_goal_id"
    t.index ["question_id"], name: "index_bot_actions_on_question_id"
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
    t.index ["inbox_id"], name: "index_bot_campaigns_on_inbox_id", unique: true
  end

  create_table "bots", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.integer "last_edited_by_id", null: false
    t.datetime "last_edited_at", null: false
    t.index ["account_id"], name: "index_bots_on_account_id"
    t.index ["name", "organization_id"], name: "index_bots_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_bots_on_organization_id"
    t.index ["person_id"], name: "index_bots_on_person_id"
  end

  create_table "campaign_contacts", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "phone_number_id", null: false
    t.bigint "question_id"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "contact_id"], name: "index_campaign_contacts_on_campaign_id_and_contact_id", unique: true
    t.index ["campaign_id"], name: "index_campaign_contacts_on_campaign_id"
    t.index ["contact_id", "phone_number_id"], name: "index_campaign_contacts_on_contact_id_and_phone_number_id", unique: true, where: "(state = 1)"
    t.index ["contact_id"], name: "index_campaign_contacts_on_contact_id"
    t.index ["phone_number_id"], name: "index_campaign_contacts_on_phone_number_id"
    t.index ["question_id"], name: "index_campaign_contacts_on_question_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "last_edited_at", null: false
    t.integer "last_edited_by_id", null: false
    t.datetime "last_paused_at"
    t.index ["account_id"], name: "index_campaigns_on_account_id"
    t.index ["name"], name: "index_campaigns_on_name"
    t.index ["organization_id", "name"], name: "index_campaigns_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_campaigns_on_organization_id"
  end

  create_table "charges", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.string "stripe_id", null: false
    t.string "object"
    t.integer "amount"
    t.integer "amount_refunded"
    t.string "application"
    t.string "application_fee"
    t.string "balance_transaction"
    t.boolean "captured"
    t.integer "created"
    t.string "currency"
    t.string "customer"
    t.string "description"
    t.string "destination"
    t.string "dispute"
    t.string "failure_code"
    t.string "failure_message"
    t.jsonb "fraud_details", default: {}
    t.string "invoice"
    t.boolean "livemode"
    t.jsonb "metadata", default: {}
    t.string "on_behalf_of"
    t.string "order"
    t.jsonb "outcome", default: {}
    t.boolean "paid"
    t.string "receipt_email"
    t.string "receipt_number"
    t.boolean "refunded"
    t.jsonb "refunds", default: {}
    t.string "review"
    t.jsonb "shipping", default: {}
    t.jsonb "source", default: {}
    t.string "source_transfer"
    t.string "statement_descriptor"
    t.string "status"
    t.string "transfer"
    t.string "transfer_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice"], name: "index_charges_on_invoice"
    t.index ["invoice_id"], name: "index_charges_on_invoice_id"
    t.index ["stripe_id"], name: "index_charges_on_stripe_id", unique: true
  end

  create_table "column_mappings", force: :cascade do |t|
    t.bigint "import_id", null: false
    t.string "contact_attribute", null: false
    t.integer "column_number"
    t.boolean "optional", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id"], name: "index_column_mappings_on_import_id"
  end

  create_table "contact_stages", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.integer "rank", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "editable", default: true, null: false
    t.index ["organization_id", "name"], name: "index_contact_stages_on_organization_id_and_name", unique: true
    t.index ["organization_id"], name: "index_contact_stages_on_organization_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "organization_id", null: false
    t.boolean "subscribed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_reply_at"
    t.bigint "team_id"
    t.bigint "contact_stage_id", null: false
    t.string "nickname"
    t.string "name"
    t.string "phone_number", null: false
    t.integer "messages_count", default: 0, null: false
    t.bigint "zipcode_id"
    t.string "source"
    t.index ["contact_stage_id"], name: "index_contacts_on_contact_stage_id"
    t.index ["organization_id", "nickname"], name: "index_contacts_on_organization_id_and_nickname", unique: true
    t.index ["organization_id", "phone_number"], name: "index_contacts_on_organization_id_and_phone_number", unique: true
    t.index ["organization_id"], name: "index_contacts_on_organization_id"
    t.index ["person_id", "organization_id"], name: "index_contacts_on_person_id_and_organization_id", unique: true
    t.index ["person_id"], name: "index_contacts_on_person_id"
    t.index ["team_id"], name: "index_contacts_on_team_id"
    t.index ["zipcode_id"], name: "index_contacts_on_zipcode_id"
  end

  create_table "contacts_imports", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "import_id", null: false
    t.boolean "updated", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contacts_imports_on_contact_id"
    t.index ["import_id"], name: "index_contacts_imports_on_import_id"
  end

  create_table "conversation_parts", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "message_id", null: false
    t.datetime "happened_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "campaign_id"
    t.index ["campaign_id"], name: "index_conversation_parts_on_campaign_id"
    t.index ["conversation_id"], name: "index_conversation_parts_on_conversation_id"
    t.index ["message_id"], name: "index_conversation_parts_on_message_id", unique: true
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
    t.datetime "last_conversation_part_created_at"
    t.datetime "closed_at"
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["phone_number_id"], name: "index_conversations_on_phone_number_id"
    t.index ["state", "contact_id", "phone_number_id"], name: "index_conversations_on_state_and_contact_id_and_phone_number_id", unique: true, where: "(state = 0)"
  end

  create_table "follow_ups", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "body", null: false
    t.integer "action", default: 0, null: false
    t.string "type", default: "ChoiceFollowUp", null: false
    t.integer "next_question_id"
    t.bigint "goal_id"
    t.integer "rank", null: false
    t.string "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "location", default: true, null: false
    t.datetime "deleted_at"
    t.bigint "bot_action_id", null: false
    t.index ["bot_action_id"], name: "index_follow_ups_on_bot_action_id"
    t.index ["deleted_at"], name: "index_follow_ups_on_deleted_at"
    t.index ["goal_id"], name: "index_follow_ups_on_goal_id"
    t.index ["next_question_id"], name: "index_follow_ups_on_next_question_id"
    t.index ["question_id"], name: "index_follow_ups_on_question_id"
    t.index ["rank", "question_id"], name: "index_follow_ups_on_rank_and_question_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "follow_ups_tags", force: :cascade do |t|
    t.bigint "follow_up_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follow_up_id", "tag_id"], name: "index_follow_ups_tags_on_follow_up_id_and_tag_id", unique: true
    t.index ["follow_up_id"], name: "index_follow_ups_tags_on_follow_up_id"
    t.index ["tag_id"], name: "index_follow_ups_tags_on_tag_id"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.text "body", null: false
    t.integer "rank", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contact_stage_id"
    t.datetime "deleted_at"
    t.index ["bot_id"], name: "index_goals_on_bot_id"
    t.index ["contact_stage_id"], name: "index_goals_on_contact_stage_id"
    t.index ["deleted_at"], name: "index_goals_on_deleted_at"
    t.index ["rank", "bot_id"], name: "index_goals_on_rank_and_bot_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "greetings", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_greetings_on_bot_id"
  end

  create_table "import_errors", force: :cascade do |t|
    t.bigint "import_id", null: false
    t.integer "row_number", null: false
    t.integer "column_number", null: false
    t.integer "error_type", null: false
    t.string "column_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id"], name: "index_import_errors_on_import_id"
  end

  create_table "imports", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "status", default: 0, null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_imports_on_account_id"
  end

  create_table "imports_tags", force: :cascade do |t|
    t.bigint "import_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id", "tag_id"], name: "index_imports_tags_on_import_id_and_tag_id", unique: true
    t.index ["import_id"], name: "index_imports_tags_on_import_id"
    t.index ["tag_id"], name: "index_imports_tags_on_tag_id"
  end

  create_table "inboxes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unread_count", default: 0, null: false
    t.bigint "team_id", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.string "stripe_id", null: false
    t.string "object"
    t.integer "amount_due"
    t.integer "application_fee"
    t.integer "attempt_count"
    t.boolean "attempted"
    t.string "billing"
    t.string "charge"
    t.boolean "closed"
    t.string "currency"
    t.string "customer"
    t.integer "date"
    t.string "description"
    t.jsonb "discount", default: {}
    t.integer "due_date"
    t.integer "ending_balance"
    t.boolean "forgiven"
    t.jsonb "lines", default: {}
    t.boolean "livemode"
    t.jsonb "metadata", default: {}
    t.integer "next_payment_attempt"
    t.string "number"
    t.boolean "paid"
    t.integer "period_end"
    t.integer "period_start"
    t.string "receipt_number"
    t.integer "starting_balance"
    t.string "statement_descriptor"
    t.string "subscription"
    t.integer "subscription_proration_date"
    t.integer "subtotal"
    t.integer "tax"
    t.float "tax_percent"
    t.integer "total"
    t.integer "webhooks_delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_id"], name: "index_invoices_on_stripe_id", unique: true
    t.index ["subscription_id"], name: "index_invoices_on_subscription_id"
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

  create_table "manual_message_participants", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "manual_message_id", null: false
    t.bigint "message_id"
    t.integer "reply_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_manual_message_participants_on_contact_id"
    t.index ["manual_message_id"], name: "index_manual_message_participants_on_manual_message_id"
    t.index ["message_id"], name: "index_manual_message_participants_on_message_id"
    t.index ["reply_id"], name: "index_manual_message_participants_on_reply_id"
  end

  create_table "manual_messages", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "status", default: 0, null: false
    t.text "body", null: false
    t.string "title", null: false
    t.datetime "started_sending_at"
    t.jsonb "audience", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_manual_messages_on_account_id"
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
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id"
    t.integer "recipient_id"
    t.bigint "conversation_id"
    t.string "from", null: false
    t.string "to", null: false
    t.bigint "campaign_id"
    t.index ["campaign_id"], name: "index_messages_on_campaign_id"
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
    t.string "stripe_customer_id"
    t.string "size"
    t.string "forwarding_phone_number"
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
    t.index ["zipcode_id"], name: "index_people_on_zipcode_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "sid", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "forwarding_phone_number"
    t.index ["organization_id"], name: "index_phone_numbers_on_organization_id"
    t.index ["phone_number"], name: "index_phone_numbers_on_phone_number", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "bot_id", null: false
    t.text "body", null: false
    t.boolean "active", default: true, null: false
    t.string "type", default: "ChoiceQuestion", null: false
    t.integer "rank", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["bot_id"], name: "index_questions_on_bot_id"
    t.index ["deleted_at"], name: "index_questions_on_deleted_at"
    t.index ["rank", "bot_id"], name: "index_questions_on_rank_and_bot_id", unique: true, where: "(deleted_at IS NULL)"
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

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "canceled_at"
    t.datetime "trial_ends_at"
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "description"
    t.index ["name", "organization_id"], name: "index_teams_on_name_and_organization_id", unique: true
    t.index ["organization_id"], name: "index_teams_on_organization_id"
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
  add_foreign_key "accounts", "people"
  add_foreign_key "assignment_rules", "inboxes"
  add_foreign_key "assignment_rules", "organizations"
  add_foreign_key "assignment_rules", "phone_numbers"
  add_foreign_key "bot_actions", "bots"
  add_foreign_key "bot_actions", "goals"
  add_foreign_key "bot_actions", "questions"
  add_foreign_key "bot_campaigns", "bots"
  add_foreign_key "bot_campaigns", "campaigns"
  add_foreign_key "bot_campaigns", "inboxes"
  add_foreign_key "bots", "accounts"
  add_foreign_key "bots", "accounts", column: "last_edited_by_id"
  add_foreign_key "bots", "organizations"
  add_foreign_key "bots", "people"
  add_foreign_key "campaign_contacts", "campaigns"
  add_foreign_key "campaign_contacts", "contacts"
  add_foreign_key "campaign_contacts", "phone_numbers"
  add_foreign_key "campaign_contacts", "questions"
  add_foreign_key "campaigns", "accounts"
  add_foreign_key "campaigns", "accounts", column: "last_edited_by_id"
  add_foreign_key "campaigns", "organizations"
  add_foreign_key "charges", "invoices"
  add_foreign_key "column_mappings", "imports"
  add_foreign_key "contact_stages", "organizations"
  add_foreign_key "contacts", "contact_stages"
  add_foreign_key "contacts", "organizations"
  add_foreign_key "contacts", "people"
  add_foreign_key "contacts", "teams"
  add_foreign_key "contacts", "zipcodes"
  add_foreign_key "contacts_imports", "contacts"
  add_foreign_key "contacts_imports", "imports"
  add_foreign_key "conversation_parts", "campaigns"
  add_foreign_key "conversation_parts", "conversations"
  add_foreign_key "conversation_parts", "messages"
  add_foreign_key "conversations", "contacts"
  add_foreign_key "conversations", "phone_numbers"
  add_foreign_key "follow_ups", "bot_actions"
  add_foreign_key "follow_ups", "goals"
  add_foreign_key "follow_ups", "questions"
  add_foreign_key "follow_ups", "questions", column: "next_question_id"
  add_foreign_key "follow_ups_tags", "follow_ups"
  add_foreign_key "follow_ups_tags", "tags"
  add_foreign_key "goals", "bots"
  add_foreign_key "goals", "contact_stages"
  add_foreign_key "greetings", "bots"
  add_foreign_key "import_errors", "imports"
  add_foreign_key "imports", "accounts"
  add_foreign_key "imports_tags", "imports"
  add_foreign_key "imports_tags", "tags"
  add_foreign_key "invoices", "subscriptions"
  add_foreign_key "locations", "teams"
  add_foreign_key "manual_message_participants", "contacts"
  add_foreign_key "manual_message_participants", "manual_messages"
  add_foreign_key "manual_message_participants", "messages"
  add_foreign_key "manual_message_participants", "messages", column: "reply_id"
  add_foreign_key "manual_messages", "accounts"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "teams"
  add_foreign_key "messages", "campaigns"
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
  add_foreign_key "subscriptions", "organizations"
  add_foreign_key "taggings", "contacts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "organizations"
  add_foreign_key "teams", "organizations"
end
