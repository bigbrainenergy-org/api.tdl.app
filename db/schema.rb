# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_23_113436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_requests", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "reason_for_interest", null: false
    t.string "version", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_access_requests_on_email", unique: true
  end

  create_table "contexts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "color", null: false
    t.string "icon", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title", "user_id"], name: "index_contexts_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_contexts_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "push_endpoint", null: false
    t.string "push_p256dh", null: false
    t.string "push_auth", null: false
    t.string "user_agent", null: false
    t.datetime "last_seen_at", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "inbox_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_inbox_items_on_user_id"
  end

  create_table "next_action_relationships", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "first_id", null: false
    t.bigint "second_id", null: false
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_id", "second_id", "type"], name: "unique_next_action_relationships", unique: true
    t.index ["first_id"], name: "index_next_action_relationships_on_first_id"
    t.index ["second_id"], name: "index_next_action_relationships_on_second_id"
  end

  create_table "next_actions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "context_id"
    t.bigint "project_id"
    t.string "title", null: false
    t.string "notes"
    t.integer "order", default: 0, null: false
    t.boolean "completed", default: false, null: false
    t.datetime "remind_me_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["context_id"], name: "index_next_actions_on_context_id"
    t.index ["project_id"], name: "index_next_actions_on_project_id"
    t.index ["user_id"], name: "index_next_actions_on_user_id"
  end

  create_table "project_relationships", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "first_id", null: false
    t.bigint "second_id", null: false
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_id", "second_id", "type"], name: "unique_project_relationships", unique: true
    t.index ["first_id"], name: "index_project_relationships_on_first_id"
    t.index ["second_id"], name: "index_project_relationships_on_second_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "notes"
    t.integer "order", default: 0, null: false
    t.string "status", default: "active", null: false
    t.datetime "status_last_changed_at"
    t.datetime "deadline_at"
    t.string "estimated_time_to_complete"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title", "user_id"], name: "index_projects_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "subtasks", force: :cascade do |t|
    t.bigint "next_action_id", null: false
    t.string "title", null: false
    t.integer "order", default: 0, null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["next_action_id"], name: "index_subtasks_on_next_action_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "given_name", null: false
    t.string "family_name", null: false
    t.string "time_zone", default: "UTC", null: false
    t.string "locale", default: "en", null: false
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.integer "failed_logins_count", default: 0, null: false
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.datetime "terms_and_conditions", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "waiting_fors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "notes"
    t.integer "order", default: 0, null: false
    t.datetime "next_checkin_at"
    t.datetime "deadline_at"
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_waiting_fors_on_user_id"
  end

  add_foreign_key "contexts", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "inbox_items", "users"
  add_foreign_key "next_actions", "contexts"
  add_foreign_key "next_actions", "projects"
  add_foreign_key "next_actions", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "subtasks", "next_actions"
  add_foreign_key "user_sessions", "users"
  add_foreign_key "waiting_fors", "users"
end
