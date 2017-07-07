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

ActiveRecord::Schema.define(version: 20170707001638) do

  create_table "list_invitation_records", force: :cascade do |t|
    t.string "list_id"
    t.string "title"
    t.text "guests"
    t.string "phone"
    t.string "email"
    t.boolean "is_delivered"
    t.boolean "is_assistance_confirmed"
    t.integer "confirmed_guests_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "list_people_records", force: :cascade do |t|
    t.string "list_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "wedding_roll"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "list_records", force: :cascade do |t|
    t.string "list_id"
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_records", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "user_type"
    t.string "password_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
