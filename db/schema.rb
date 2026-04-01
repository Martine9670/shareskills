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

ActiveRecord::Schema[8.1].define(version: 2026_04_01_134736) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "proposed_at"
    t.boolean "read", default: false, null: false
    t.integer "receiver_id"
    t.integer "sender_id"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "swaps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "duration"
    t.text "message"
    t.integer "proposer_id", null: false
    t.integer "receiver_id", null: false
    t.integer "skill_id", null: false
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.index ["proposer_id"], name: "index_swaps_on_proposer_id"
    t.index ["receiver_id"], name: "index_swaps_on_receiver_id"
    t.index ["skill_id"], name: "index_swaps_on_skill_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level"
    t.integer "skill_id", null: false
    t.string "skill_type"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.integer "credits_minutes", default: 120
    t.string "email"
    t.boolean "is_admin", default: false
    t.string "location"
    t.string "name"
    t.string "password_digest"
    t.float "rating", default: 0.0
    t.integer "swaps_count", default: 0
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "swaps", "skills"
  add_foreign_key "swaps", "users", column: "proposer_id"
  add_foreign_key "swaps", "users", column: "receiver_id"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
