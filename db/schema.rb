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

ActiveRecord::Schema.define(version: 20140607110841) do

  create_table "documents", force: true do |t|
    t.datetime "received_at"
    t.string   "received_no"
    t.string   "sent_from"
    t.string   "doc_type"
    t.string   "sent_no"
    t.text     "title"
    t.string   "office"
    t.integer  "user_id"
    t.datetime "user_get"
    t.datetime "user_back"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "userid_get"
    t.integer  "userid_back"
    t.integer  "star"
  end

  create_table "offices", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role"
    t.string   "office"
  end

end
