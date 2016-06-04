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

ActiveRecord::Schema.define(version: 20160603212103) do

  create_table "categories", force: :cascade do |t|
    t.date     "first_day"
    t.date     "last_day"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id"

  create_table "runs", force: :cascade do |t|
    t.datetime "datetime"
    t.decimal  "distance"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "time_zone"
  end

  create_table "week_goals", force: :cascade do |t|
    t.date     "first_day"
    t.date     "last_day"
    t.integer  "number"
    t.integer  "user_id"
    t.decimal  "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "week_goals", ["user_id"], name: "index_week_goals_on_user_id"

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
