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

ActiveRecord::Schema.define(:version => 20121216002034) do

  create_table "account_balances", :force => true do |t|
    t.integer  "user_id"
    t.float    "current_balance", :default => 0.0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
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

  create_table "imports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "list_id"
    t.string   "file_name"
    t.integer  "number_of_contacts"
    t.boolean  "hold"
    t.boolean  "uploaded"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
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
    t.float    "debit",           :default => 0.0
    t.float    "credit",          :default => 0.0
    t.float    "current_balance", :default => 0.0
    t.string   "memo"
    t.boolean  "free"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "twilio_phone_numbers", :force => true do |t|
    t.integer  "user_id"
    t.string   "area_code"
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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
