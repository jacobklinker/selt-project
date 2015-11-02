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

ActiveRecord::Schema.define(version: 20151102191239) do

  create_table "games", force: :cascade do |t|
    t.string   "home_team",                   null: false
    t.string   "away_team",                   null: false
    t.float    "home_odds"
    t.float    "away_odds"
    t.integer  "home_score"
    t.integer  "away_score"
    t.boolean  "is_finished", default: false
    t.datetime "game_time"
  end

  create_table "score_syncs", force: :cascade do |t|
    t.datetime "sync_start"
    t.integer  "tweets_found",  default: 0
    t.integer  "tweets_used",   default: 0
    t.boolean  "is_successful", default: true
  end

  create_table "syncs", force: :cascade do |t|
    t.datetime "timestamp"
    t.integer  "new_games",     default: 0
    t.integer  "updated_games", default: 0
    t.integer  "failed_games",  default: 0
    t.boolean  "is_successful", default: true
  end

  create_table "users", force: :cascade do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
