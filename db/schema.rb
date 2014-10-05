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

ActiveRecord::Schema.define(:version => 20141005150720) do

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.integer  "max_calls"
    t.integer  "calls_per_second"
    t.integer  "max_concurrent"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.string   "transport_type"
  end

  create_table "rtcp_data", :force => true do |t|
    t.integer  "test_run_id"
    t.time     "time"
    t.float    "max_packet_loss"
    t.float    "avg_packet_loss"
    t.float    "max_jitter"
    t.float    "avg_jitter"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "scenarios", :force => true do |t|
    t.string   "name"
    t.text     "sipp_xml"
    t.string   "pcap_audio"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.text     "sippy_cup_scenario"
    t.text     "csv_data"
    t.boolean  "receiver",           :default => false
    t.integer  "user_id"
    t.integer  "scenario_id"
    t.text     "description"
  end

  create_table "sipp_data", :force => true do |t|
    t.integer  "test_run_id"
    t.time     "time"
    t.integer  "successful_calls"
    t.integer  "failed_calls"
    t.integer  "total_calls"
    t.float    "cps"
    t.integer  "concurrent_calls"
    t.float    "avg_call_duration"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "response_time"
  end

  create_table "system_load_data", :force => true do |t|
    t.integer  "test_run_id"
    t.float    "cpu"
    t.float    "memory"
    t.datetime "logged_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "targets", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.string   "ssh_username"
  end

  create_table "test_runs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "scenario_id"
    t.integer  "profile_id"
    t.integer  "target_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_id"
    t.string   "jid"
    t.string   "state"
    t.datetime "enqueued_at"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "receiver_scenario_id"
    t.string   "error_name"
    t.text     "error_message"
    t.text     "summary_report"
    t.text     "errors_report"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "admin",        :default => false
    t.boolean  "admin_mode",   :default => false
    t.string   "name"
  end

end
