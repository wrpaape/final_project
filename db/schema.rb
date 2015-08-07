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

ActiveRecord::Schema.define(version: 20150805195539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "act_rec_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "module"
    t.string   "syntax"
    t.text     "description"
    t.text     "example"
    t.text     "source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "baby_names", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "frequency"
    t.integer  "yob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.float    "revenue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communities", force: :cascade do |t|
    t.string   "name"
    t.date     "founded_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "communities_programmers", id: false, force: :cascade do |t|
    t.integer "community_id",  null: false
    t.integer "programmer_id", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.float    "weight"
    t.float    "price"
    t.date     "start"
    t.date     "finish"
    t.integer  "farmer_id"
    t.integer  "crop_id"
    t.integer  "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contracts", ["client_id"], name: "index_contracts_on_client_id", using: :btree
  add_index "contracts", ["crop_id"], name: "index_contracts_on_crop_id", using: :btree
  add_index "contracts", ["farmer_id"], name: "index_contracts_on_farmer_id", using: :btree

  create_table "crops", force: :cascade do |t|
    t.string   "name"
    t.float    "yield"
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

  create_table "farmers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "farms", force: :cascade do |t|
    t.float    "maintenance"
    t.integer  "farmer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "farms", ["farmer_id"], name: "index_farms_on_farmer_id", using: :btree

  create_table "fields", force: :cascade do |t|
    t.float    "size"
    t.float    "upkeep"
    t.integer  "farm_id"
    t.integer  "crop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fields", ["crop_id"], name: "index_fields_on_crop_id", using: :btree
  add_index "fields", ["farm_id"], name: "index_fields_on_farm_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.integer  "yoc"
    t.string   "creator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages_predecessors", id: false, force: :cascade do |t|
    t.integer "language_id"
    t.integer "predecessor_id"
  end

  add_index "languages_predecessors", ["language_id"], name: "index_languages_predecessors_on_language_id", using: :btree
  add_index "languages_predecessors", ["predecessor_id"], name: "index_languages_predecessors_on_predecessor_id", using: :btree

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

  create_table "programmers", force: :cascade do |t|
    t.string   "type",         default: "Programmer"
    t.string   "name"
    t.integer  "executive_id"
    t.integer  "senior_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "manager_id"
    t.string   "manager_type"
    t.string   "name"
    t.integer  "points_total"
    t.date     "founded_on"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "projects", ["manager_id"], name: "index_projects_on_manager_id", using: :btree

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

  create_table "studies", force: :cascade do |t|
    t.float    "aptitude"
    t.integer  "programmer_id"
    t.integer  "language_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "assigner_id"
    t.string   "assigner_type"
    t.string   "description"
    t.integer  "points"
    t.boolean  "completed"
    t.datetime "assigned_at"
    t.integer  "project_id",    null: false
    t.integer  "receiver_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "password_confirmation"
    t.boolean  "admin",                  default: false
    t.integer  "problems_count",         default: 0
    t.integer  "solved_problems_count",  default: 0
    t.integer  "environments_cleared",   default: 0
    t.integer  "problem_id"
    t.integer  "environment_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["environment_id"], name: "index_users_on_environment_id", using: :btree
  add_index "users", ["problem_id"], name: "index_users_on_problem_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "views", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "views", ["email"], name: "index_views_on_email", unique: true, using: :btree
  add_index "views", ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "contracts", "clients"
  add_foreign_key "contracts", "crops"
  add_foreign_key "contracts", "farmers"
  add_foreign_key "farms", "farmers"
  add_foreign_key "fields", "crops"
  add_foreign_key "fields", "farms"
  add_foreign_key "problems", "environments"
  add_foreign_key "solved_problems", "environments"
  add_foreign_key "solved_problems", "problems"
  add_foreign_key "solved_problems", "users"
  add_foreign_key "users", "environments"
  add_foreign_key "users", "problems"
end
