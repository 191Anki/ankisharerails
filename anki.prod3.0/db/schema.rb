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

ActiveRecord::Schema.define(version: 20150128185602) do

  create_table "cards", force: true do |t|
    t.integer  "card_id"
    t.string   "card_front"
    t.string   "card_back"
    t.integer  "deck_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_names", force: true do |t|
    t.string   "cname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "decks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.string   "class_name_id"
    t.string   "year_id"
    t.string   "attachment"
    t.string   "notes"
    t.string   "professor_id"
    t.string   "topic_id"
    t.integer  "deck_id"
    t.integer  "counter",       default: 0
    t.string   "user_name"
  end

  create_table "professors", force: true do |t|
    t.string   "prof_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "topic_name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_year"
    t.string   "user_name"
    t.integer  "ecounter",               default: 0
    t.integer  "ucounter",               default: 0
    t.integer  "dcounter",               default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "years", force: true do |t|
    t.string   "year_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
