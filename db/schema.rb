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

ActiveRecord::Schema.define(:version => 20111118082633) do

  create_table "country_masters", :force => true do |t|
    t.string   "country_name", :null => false
    t.string   "code_two",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gateways", :force => true do |t|
    t.string   "gateway"
    t.string   "gateway_login"
    t.string   "gateway_key"
    t.boolean  "isEnabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_details", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.integer  "cc_id"
    t.string   "gateway_trans_type"
    t.string   "gateway_pay_status"
    t.datetime "gateway_trans_time"
    t.string   "gateway_description"
    t.string   "cc_trans_id"
    t.integer  "profile_id"
    t.float    "amount_Credited"
    t.datetime "payment_date"
    t.string   "payment_description"
    t.integer  "payment_status"
    t.integer  "invoice_type_id"
    t.datetime "next_due_date"
    t.float    "amount_debited"
    t.float    "additional_credit"
    t.string   "subscription_status"
    t.string   "transaction_type"
    t.datetime "pay_success_date"
    t.integer  "gateway_id"
    t.integer  "basic_invoice"
    t.integer  "pay_mode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_types", :force => true do |t|
    t.string   "invoice_type"
    t.string   "invoice_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licences", :force => true do |t|
    t.integer  "customer_id"
    t.text     "code"
    t.string   "key"
    t.text     "user_key"
    t.integer  "tot_vps"
    t.integer  "tot_servers"
    t.datetime "activated_on"
    t.datetime "expired_on"
    t.string   "status"
    t.integer  "verified"
    t.text     "macAddress"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "placeholders", :force => true do |t|
    t.integer  "template_id"
    t.string   "data"
    t.string   "function"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plan_billing_rates", :force => true do |t|
    t.integer  "plan_id"
    t.float    "rec_monthly"
    t.float    "rec_quaterly"
    t.float    "rec_semiyear"
    t.float    "rec_yearly"
    t.integer  "monthly"
    t.integer  "quaterly"
    t.integer  "semi"
    t.integer  "yearly"
    t.integer  "active_plan"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.integer  "plan_billing_rates_id"
    t.string   "title"
    t.integer  "vps"
    t.integer  "isavailable"
    t.integer  "isdeleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "state_masters", :force => true do |t|
    t.string   "state_name",      :null => false
    t.string   "code_two",        :null => false
    t.integer  "state_contry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.integer  "plan_id"
    t.integer  "user_id"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "billing_period"
    t.integer  "next_billing_period"
  end

  create_table "ticket_details", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "replier_id"
    t.text     "reply"
    t.text     "comments"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "user_id"
    t.string   "priority"
    t.string   "subject"
    t.string   "category"
    t.text     "comments"
    t.string   "status",     :default => "Open"
    t.boolean  "isdelete",   :default => false
    t.string   "random"
    t.integer  "replies"
    t.string   "replier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_billing_addresses", :force => true do |t|
    t.integer  "user_id"
    t.text     "address"
    t.text     "address2"
    t.string   "city"
    t.integer  "state"
    t.string   "state_other"
    t.integer  "country"
    t.string   "postal_code"
    t.string   "phccode"
    t.string   "phacode"
    t.string   "phnumber"
    t.string   "phextension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_plans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.float    "fraudScore"
    t.string   "billingperiod"
    t.datetime "insertTS"
    t.integer  "plan_current_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "roles_id"
    t.string   "username"
    t.string   "password"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "address"
    t.text     "address2"
    t.string   "city"
    t.integer  "state"
    t.string   "state_other"
    t.integer  "country"
    t.string   "postal_code"
    t.string   "account_type",   :default => "Client"
    t.string   "company"
    t.string   "phccode"
    t.string   "phacode"
    t.string   "phnumber"
    t.string   "mccode"
    t.string   "macode"
    t.string   "mnumber"
    t.string   "fccode"
    t.string   "facode"
    t.string   "fnumber"
    t.datetime "last_login"
    t.string   "last_ip_used"
    t.datetime "registered_on"
    t.string   "isreseller"
    t.string   "status"
    t.text     "description"
    t.string   "authorize_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
