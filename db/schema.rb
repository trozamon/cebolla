# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_11_19_130309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.string "line1", null: false
    t.string "line2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.integer "default_hourly_rate_cents", default: 0
    t.string "default_hourly_rate_currency", default: "USD"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "entities", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.integer "starting_invoice", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hours", force: :cascade do |t|
    t.date "date"
    t.decimal "num"
    t.text "description"
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "line_item_id"
    t.index ["line_item_id"], name: "index_hours_on_line_item_id"
    t.index ["task_id"], name: "index_hours_on_task_id"
    t.index ["user_id"], name: "index_hours_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "number", null: false
    t.bigint "entity_id", null: false
    t.bigint "customer_id", null: false
    t.date "date", null: false
    t.date "due_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "posted_at"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["entity_id"], name: "index_invoices_on_entity_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.decimal "quantity", null: false
    t.integer "unit_amount_cents", default: 0, null: false
    t.string "unit_amount_currency", default: "USD", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "customer_id", null: false
    t.integer "default_hourly_rate_cents", default: 0
    t.string "default_hourly_rate_currency", default: "USD"
    t.string "name", null: false
    t.date "due_date"
    t.integer "billing", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "archived_at"
    t.text "description"
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["entity_id"], name: "index_projects_on_entity_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "subject", null: false
    t.text "description"
    t.integer "kind", null: false
    t.integer "state", null: false
    t.decimal "est_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "hours", "tasks"
  add_foreign_key "hours", "users"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "entities"
  add_foreign_key "line_items", "invoices"
  add_foreign_key "projects", "customers"
  add_foreign_key "projects", "entities"
  add_foreign_key "tasks", "projects"
end
