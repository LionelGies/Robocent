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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130118091602) do

  create_table "account_balances", :force => true do |t|
    t.integer  "user_id"
    t.float    "current_balance", :default => 0.0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "billing_events", :force => true do |t|
    t.integer  "user_id"
    t.string   "event_type"
    t.text     "response"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "billing_settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "stripe_id"
    t.string   "card_last_four_digits"
    t.date     "card_expiry_date"
    t.string   "card_type"
    t.string   "card_holder_name"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "call_queue", :force => true do |t|
    t.integer "order"
    t.string  "phone",         :limit => 20
    t.enum    "status",        :limit => [:NOT_DIALED, :DIALING, :DIALED, :CACHED]
    t.string  "calleridname",  :limit => 50
    t.string  "calleridnum",   :limit => 30
    t.string  "recordingname", :limit => 200
    t.string  "dialingserver", :limit => 50
  end

  add_index "call_queue", ["dialingserver"], :name => "dialingserver"

  create_table "calls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recording_id"
    t.string   "caller_id_number"
    t.string   "list_ids"
    t.string   "test_send_to"
    t.integer  "number_of_recipients"
    t.float    "cost_per_call"
    t.float    "total_cost"
    t.datetime "schedule_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.string   "phone_number"
    t.string   "unique_identifier"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "do_not_import"
    t.string   "company_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "custom_1"
    t.string   "custom_2"
    t.string   "custom_3"
    t.string   "custom_4"
    t.string   "custom_5"
    t.string   "source"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dnc", :force => true do |t|
    t.string   "phone"
    t.integer  "account"
    t.boolean  "global"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "imports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.string   "file_name"
    t.integer  "number_of_contacts"
    t.boolean  "hold"
    t.boolean  "uploaded"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "mapping"
  end

  create_table "lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "type_of_list"
    t.integer  "number_of_contacts", :default => 0
    t.string   "keyword"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "plan_migrations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "new_plan_id"
    t.datetime "schedule_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "stripe_id"
    t.integer  "amount"
    t.string   "currency"
    t.string   "interval"
    t.string   "name"
    t.integer  "trial_period_days"
    t.integer  "minimum_numbers"
    t.integer  "maximum_numbers"
    t.float    "price_per_call_or_text"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "receipts", :force => true do |t|
    t.integer  "user_id"
    t.float    "debit",            :default => 0.0
    t.float    "credit",           :default => 0.0
    t.float    "current_balance",  :default => 0.0
    t.string   "memo"
    t.boolean  "free"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "stripe_charge_id"
  end

  create_table "recordings", :force => true do |t|
    t.string   "title"
    t.string   "sid"
    t.text     "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "userID"
    t.string   "file"
    t.string   "duration"
    t.string   "file_length"
  end

  create_table "results", :force => true do |t|
    t.integer "call_id",     :limit => 8,   :null => false
    t.integer "orderID"
    t.string  "phone",       :limit => 20
    t.string  "pass",        :limit => 15
    t.string  "dial_start",  :limit => 100
    t.string  "dial_dur",    :limit => 15
    t.string  "call_result", :limit => 100
    t.string  "call_start",  :limit => 100
    t.string  "call_dur",    :limit => 15
    t.integer "on_time"
  end

  create_table "sms_messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "sms_sid"
    t.text     "body"
    t.string   "from"
    t.string   "from_state"
    t.string   "from_city"
    t.string   "from_country"
    t.string   "from_zip"
    t.string   "to"
    t.string   "status"
    t.integer  "contact_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "temp_users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "test_calls", :force => true do |t|
    t.integer "userID"
    t.string  "phone",         :limit => 10
    t.enum    "status",        :limit => [:NOT_DIALED, :DIALING, :DIALED, :CACHED]
    t.string  "calleridname",  :limit => 50,                                        :default => "ROBOCENT"
    t.string  "calleridnum",   :limit => 30,                                        :default => "7578212121"
    t.string  "recordingname", :limit => 200
    t.string  "dialingserver", :limit => 50
  end

  add_index "test_calls", ["dialingserver"], :name => "dialingserver"

  create_table "text_messages", :force => true do |t|
    t.text     "content"
    t.integer  "sending_option"
    t.string   "test_send_to"
    t.integer  "user_id"
    t.integer  "number_of_recipients"
    t.float    "cost_per_text"
    t.integer  "number_of_texts_required"
    t.float    "total_cost"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "list_ids"
    t.datetime "schedule_at"
    t.integer  "total_processed",          :default => 0
    t.integer  "succeeded",                :default => 0
    t.text     "succeeded_numbers"
    t.text     "failed_alerts"
    t.datetime "started_at"
    t.datetime "finished_at"
  end

  create_table "tmp_messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "twilio_phone_numbers", :force => true do |t|
    t.integer  "user_id"
    t.string   "area_code"
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "pin_number"
  end

  create_table "users", :force => true do |t|
    t.string   "organization_name"
    t.string   "organization_type"
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "time_zone"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.integer  "failed_logins_count",             :default => 0
    t.datetime "lock_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "address"
    t.string   "state"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
