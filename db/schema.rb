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

ActiveRecord::Schema.define(:version => 20121202113820) do

  create_table "clients", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.string   "website"
    t.integer  "user_id",     :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "role"
    t.string   "email"
    t.string   "phone"
    t.integer  "client_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "enquiries", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.integer  "user_id"
    t.boolean  "viewed",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "details"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_public",  :default => false
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",    :default => false
  end

  create_table "phases", :force => true do |t|
    t.string   "title",                           :null => false
    t.text     "details"
    t.boolean  "is_flat_rate", :default => false
    t.float    "flat_rate",    :default => 0.0
    t.date     "due_date"
    t.boolean  "is_done",      :default => false
    t.integer  "project_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "order_index"
  end

  create_table "projects", :force => true do |t|
    t.string   "title",                                  :null => false
    t.text     "details"
    t.float    "quotation",           :default => 0.0
    t.boolean  "is_done",             :default => false
    t.float    "hourly_rate",         :default => 0.0
    t.float    "deposit",             :default => 0.0
    t.boolean  "deposit_paid",        :default => false
    t.boolean  "is_paid_in_full",     :default => false
    t.integer  "client_id"
    t.date     "deadline"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "has_client_view",     :default => false
    t.text     "client_view_message"
    t.string   "long_id"
  end

  add_index "projects", ["long_id"], :name => "index_projects_on_long_id", :unique => true

  create_table "tasks", :force => true do |t|
    t.string   "title",                         :null => false
    t.boolean  "is_done",    :default => false
    t.integer  "phase_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                               :null => false
    t.string   "email",                                              :null => false
    t.string   "password_digest"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.boolean  "is_admin",        :default => false
    t.string   "long_id"
    t.string   "account_type"
    t.datetime "last_login"
    t.boolean  "is_active"
    t.datetime "trial_expire",    :default => '2012-12-16 11:48:52', :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["long_id"], :name => "index_users_on_long_id", :unique => true

end
