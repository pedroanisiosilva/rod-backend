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

ActiveRecord::Schema.define(version: 20160611225309) do

  create_table "categories", force: :cascade do |t|
    t.date     "first_day"
    t.date     "last_day"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id"

  create_table "events", force: :cascade do |t|
    t.integer  "type"
    t.text     "description"
    t.date     "start_date"
    t.string   "end_date"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "runs", force: :cascade do |t|
    t.datetime "datetime"
    t.decimal  "distance"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.text     "note"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "time_zone"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "status",                 default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "weekly_goals", force: :cascade do |t|
    t.date     "first_day"
    t.date     "last_day"
    t.integer  "number"
    t.integer  "user_id"
    t.decimal  "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weekly_goals", ["user_id"], name: "index_weekly_goals_on_user_id"

end
