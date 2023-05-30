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

ActiveRecord::Schema[7.0].define(version: 2023_05_29_191801) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_requests", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "reason_for_interest", null: false
    t.string "version", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_access_requests_on_email", unique: true
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "push_endpoint", null: false
    t.string "push_p256dh", null: false
    t.string "push_auth", null: false
    t.string "user_agent", null: false
    t.datetime "last_seen_at", precision: nil, null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "color", null: false
    t.string "icon", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title", "user_id"], name: "index_lists_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "color", null: false
    t.string "icon", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title", "user_id"], name: "index_statuses_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "subtasks", force: :cascade do |t|
    t.string "title", null: false
    t.integer "order", default: 0, null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "task_id", null: false
    t.index ["task_id"], name: "index_subtasks_on_task_id"
  end

  create_table "task_relationships", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "first_id", null: false
    t.bigint "second_id", null: false
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_id", "second_id", "type"], name: "unique_next_action_relationships", unique: true
    t.index ["first_id"], name: "index_task_relationships_on_first_id"
    t.index ["second_id"], name: "index_task_relationships_on_second_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.string "notes"
    t.integer "order", default: 0, null: false
    t.boolean "completed", default: false, null: false
    t.datetime "remind_me_at", precision: nil
    t.integer "mental_energy_required", default: 50, null: false
    t.integer "physical_energy_required", default: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "list_id", null: false
    t.bigint "status_id"
    t.boolean "delegated"
    t.datetime "status_last_changed_at"
    t.datetime "deadline_at"
    t.integer "task_duration_in_minutes"
    t.index ["list_id"], name: "index_tasks_on_list_id"
    t.index ["status_id"], name: "index_tasks_on_status_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "last_login_at", precision: nil
    t.datetime "last_logout_at", precision: nil
    t.datetime "last_activity_at", precision: nil
    t.string "last_login_from_ip_address"
    t.integer "failed_logins_count", default: 0, null: false
    t.datetime "lock_expires_at", precision: nil
    t.string "unlock_token"
    t.datetime "terms_and_conditions", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "default_list_id"
    t.index ["default_list_id"], name: "index_users_on_default_list_id"
  end

  add_foreign_key "devices", "users"
  add_foreign_key "lists", "users"
  add_foreign_key "statuses", "users"
  add_foreign_key "subtasks", "tasks"
  add_foreign_key "user_sessions", "users"
  add_foreign_key "users", "lists", column: "default_list_id"
end
