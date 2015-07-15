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

ActiveRecord::Schema.define(version: 20150712140920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baby_names", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "frequency"
    t.integer  "yob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "environments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "models"
    t.integer  "problems_count",        default: 0
    t.integer  "users_count",           default: 0
    t.integer  "solved_problems_count", default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "yob"
    t.integer  "frequency",      default: 0
    t.integer  "generation",     default: 0
    t.integer  "children_count", default: 0
    t.integer  "mother_id"
    t.integer  "father_id"
    t.integer  "spouse_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "people", ["father_id"], name: "index_people_on_father_id", using: :btree
  add_index "people", ["mother_id"], name: "index_people_on_mother_id", using: :btree
  add_index "people", ["spouse_id"], name: "index_people_on_spouse_id", using: :btree

  create_table "problems", force: :cascade do |t|
    t.string   "title"
    t.text     "instructions"
    t.text     "answer"
    t.integer  "solved_problems_count", default: 0
    t.integer  "users_count",           default: 0
    t.integer  "environment_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "problems", ["environment_id"], name: "index_problems_on_environment_id", using: :btree

  create_table "solved_problems", force: :cascade do |t|
    t.text     "solution"
    t.integer  "sol_char_count"
    t.float    "time_exec_total"
    t.float    "time_query_total"
    t.float    "time_query_min"
    t.float    "time_query_max"
    t.float    "time_query_avg"
    t.integer  "num_queries"
    t.integer  "user_id"
    t.integer  "problem_id"
    t.integer  "environment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "solved_problems", ["environment_id"], name: "index_solved_problems_on_environment_id", using: :btree
  add_index "solved_problems", ["problem_id"], name: "index_solved_problems_on_problem_id", using: :btree
  add_index "solved_problems", ["user_id"], name: "index_solved_problems_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "password_confirmation"
    t.boolean  "admin",                 default: false
    t.integer  "problems_count",        default: 0
    t.integer  "solved_problems_count", default: 0
    t.integer  "environments_cleared",  default: 0
    t.integer  "problem_id"
    t.integer  "environment_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "users", ["environment_id"], name: "index_users_on_environment_id", using: :btree
  add_index "users", ["problem_id"], name: "index_users_on_problem_id", using: :btree

  add_foreign_key "problems", "environments"
  add_foreign_key "solved_problems", "environments"
  add_foreign_key "solved_problems", "problems"
  add_foreign_key "solved_problems", "users"
  add_foreign_key "users", "environments"
  add_foreign_key "users", "problems"
end
