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

ActiveRecord::Schema.define(version: 2021_10_18_012118) do

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

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title", "user_id"], name: "index_lists_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "rules", force: :cascade do |t|
    t.bigint "pre_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_rules_on_post_id"
    t.index ["pre_id", "post_id"], name: "index_rules_on_pre_id_and_post_id", unique: true
    t.index ["pre_id"], name: "index_rules_on_pre_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "task_id", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["task_id"], name: "index_taggings_on_task_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "color", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title", "user_id"], name: "index_tags_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "list_id", null: false
    t.string "title", null: false
    t.integer "order", default: 0, null: false
    t.string "notes"
    t.datetime "completed_at"
    t.datetime "deadline_at"
    t.datetime "prioritize_at"
    t.datetime "remind_me_at"
    t.datetime "review_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_tasks_on_list_id"
    t.index ["title", "user_id"], name: "index_tasks_on_title_and_user_id", unique: true
    t.index ["user_id"], name: "index_tasks_on_user_id"
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

  add_foreign_key "devices", "users"
  add_foreign_key "lists", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "tasks"
  add_foreign_key "tags", "users"
  add_foreign_key "tasks", "lists"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_sessions", "users"
end
