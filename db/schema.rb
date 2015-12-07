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

ActiveRecord::Schema.define(version: 20151203143954) do

  create_table "announcements", force: :cascade do |t|
    t.integer  "league_id"
    t.text     "announcement"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "home_team",                      null: false
    t.string   "away_team",                      null: false
    t.float    "home_odds"
    t.float    "away_odds"
    t.integer  "home_score"
    t.integer  "away_score"
    t.boolean  "is_finished",    default: false
    t.datetime "game_time"
    t.integer  "homeTeamCover"
    t.integer  "homeTeamCover2"
  end

  create_table "league_picks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "league_id"
    t.integer "week"
    t.integer "wins"
    t.integer "losses"
    t.integer "pushes"
    t.integer "weeklyTotal"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "league_name"
    t.integer  "commissioner_id"
    t.integer  "current_leader_id"
    t.string   "conference_settings"
    t.integer  "number_picks_settings"
    t.integer  "number_members"
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.integer  "user3_id"
    t.integer  "user4_id"
    t.integer  "user5_id"
    t.integer  "user6_id"
    t.integer  "user7_id"
    t.integer  "user8_id"
    t.integer  "user9_id"
    t.integer  "user10_id"
    t.integer  "user11_id"
    t.integer  "user12_id"
    t.integer  "user13_id"
    t.integer  "user14_id"
    t.integer  "user15_id"
    t.integer  "user16_id"
    t.integer  "user17_id"
    t.integer  "user18_id"
    t.integer  "user19_id"
    t.integer  "user20_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "leagues", ["commissioner_id"], name: "index_leagues_on_commissioner_id"
  add_index "leagues", ["current_leader_id"], name: "index_leagues_on_current_leader_id"
  add_index "leagues", ["user10_id"], name: "index_leagues_on_user10_id"
  add_index "leagues", ["user11_id"], name: "index_leagues_on_user11_id"
  add_index "leagues", ["user12_id"], name: "index_leagues_on_user12_id"
  add_index "leagues", ["user13_id"], name: "index_leagues_on_user13_id"
  add_index "leagues", ["user14_id"], name: "index_leagues_on_user14_id"
  add_index "leagues", ["user15_id"], name: "index_leagues_on_user15_id"
  add_index "leagues", ["user16_id"], name: "index_leagues_on_user16_id"
  add_index "leagues", ["user17_id"], name: "index_leagues_on_user17_id"
  add_index "leagues", ["user18_id"], name: "index_leagues_on_user18_id"
  add_index "leagues", ["user19_id"], name: "index_leagues_on_user19_id"
  add_index "leagues", ["user1_id"], name: "index_leagues_on_user1_id"
  add_index "leagues", ["user20_id"], name: "index_leagues_on_user20_id"
  add_index "leagues", ["user2_id"], name: "index_leagues_on_user2_id"
  add_index "leagues", ["user3_id"], name: "index_leagues_on_user3_id"
  add_index "leagues", ["user4_id"], name: "index_leagues_on_user4_id"
  add_index "leagues", ["user5_id"], name: "index_leagues_on_user5_id"
  add_index "leagues", ["user6_id"], name: "index_leagues_on_user6_id"
  add_index "leagues", ["user7_id"], name: "index_leagues_on_user7_id"
  add_index "leagues", ["user8_id"], name: "index_leagues_on_user8_id"
  add_index "leagues", ["user9_id"], name: "index_leagues_on_user9_id"

  create_table "picks", force: :cascade do |t|
    t.integer "game_id"
    t.boolean "home_wins"
    t.integer "league_pick_id"
  end

  create_table "score_syncs", force: :cascade do |t|
    t.datetime "sync_start"
    t.integer  "tweets_found",  default: 0
    t.integer  "tweets_used",   default: 0
    t.boolean  "is_successful", default: true
  end

  create_table "standings", force: :cascade do |t|
    t.integer  "weeklyScore"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "syncs", force: :cascade do |t|
    t.datetime "timestamp"
    t.integer  "new_games",     default: 0
    t.integer  "updated_games", default: 0
    t.integer  "failed_games",  default: 0
    t.boolean  "is_successful", default: true
  end

  create_table "tiebreaker_picks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "league_id"
    t.integer "points_estimate"
    t.integer "game_id"
    t.integer "league_pick_id"
  end

  add_index "tiebreaker_picks", ["game_id"], name: "index_tiebreaker_picks_on_game_id"
  add_index "tiebreaker_picks", ["league_pick_id"], name: "index_tiebreaker_picks_on_league_pick_id"

  create_table "tiebreakers", force: :cascade do |t|
    t.integer "league_id"
    t.integer "week"
    t.integer "game_id"
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
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "league1_id"
    t.integer  "league2_id"
    t.integer  "league3_id"
    t.integer  "league4_id"
    t.integer  "league5_id"
    t.integer  "num_leagues",            default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "weekly_winners", force: :cascade do |t|
    t.integer  "league_id"
    t.integer  "week"
    t.integer  "year"
    t.text     "winners"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
