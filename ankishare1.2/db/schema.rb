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

ActiveRecord::Schema.define(version: 20140531074917) do

  create_table "data_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flashcards", primary_key: "card_id", force: true do |t|
    t.string  "front"
    t.string  "back"
    t.binary  "image"
    t.string  "user_name",      limit: 40
    t.integer "user_id"
    t.string  "student_year"
    t.string  "subject"
    t.string  "exam_professor"
    t.string  "sub_subject"
    t.integer "votes"
    t.string  "tags",           limit: 1
    t.boolean "redundancy"
  end

  create_table "user", primary_key: "user_id", force: true do |t|
    t.string  "user_name"
    t.string  "password"
    t.string  "email"
    t.boolean "confirmation"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
