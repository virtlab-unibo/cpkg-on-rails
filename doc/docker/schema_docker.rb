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

ActiveRecord::Schema.define(version: 2012_08_28_221401) do

  create_table "archives", id: :integer, unsigned: true, options: "", force: :cascade do |t|
    t.string "uri", limit: 250
    t.string "distribution", limit: 50
    t.string "component", limit: 50
    t.string "arch", limit: 20
    t.boolean "global"
  end

  create_table "changelogs", id: :integer, unsigned: true, options: "", force: :cascade do |t|
    t.integer "package_id", null: false, unsigned: true
    t.integer "user_id", null: false, unsigned: true
    t.string "version"
    t.text "description"
    t.string "date", limit: 100
    t.string "urgency", limit: 100
    t.string "distributions", limit: 100
  end

  create_table "courses", id: :integer, unsigned: true, options: "", force: :cascade do |t|
    t.string "name"
    t.integer "degree_id"
    t.text "description"
    t.integer "year"
    t.string "abbr", limit: 10
  end

  create_table "courses_users", id: false, options: "", force: :cascade do |t|
    t.integer "user_id", null: false, unsigned: true
    t.integer "course_id", null: false, unsigned: true
  end

  create_table "degrees", id: :integer, options: "", force: :cascade do |t|
    t.string "code", limit: 6, null: false
    t.string "name", null: false
  end

  create_table "documents", id: :integer, unsigned: true, options: "", force: :cascade do |t|
    t.integer "package_id", null: false, unsigned: true
    t.string "name", limit: 200
    t.text "description"
    t.datetime "created_at"
    t.string "attach_file_name", limit: 250
    t.string "attach_content_type", limit: 100
    t.integer "attach_file_size"
    t.datetime "attach_updated_at"
    t.text "install_path"
  end

  create_table "invitations", id: :integer, options: "", force: :cascade do |t|
    t.string "email", null: false
    t.string "uuid", limit: 200, null: false
    t.date "expiration"
  end

  create_table "packages", id: :integer, unsigned: true, options: "", force: :cascade do |t|
    t.integer "archive_id", unsigned: true
    t.integer "course_id", unsigned: true
    t.string "name", null: false
    t.string "short_description"
    t.string "homepage"
    t.text "long_description"
    t.text "depends"
    t.string "version"
    t.text "filename"
  end

  create_table "scripts", id: :integer, unsigned: true, options: "", force: :cascade do |t|
    t.integer "package_id", unsigned: true
    t.string "name"
    t.string "stype", limit: 20
    t.datetime "created_at"
    t.string "attach_file_name"
    t.datetime "attach_updated_at"
    t.string "attach_content_type", limit: 100
    t.integer "attach_file_size"
  end

  create_table "users", id: :integer, unsigned: true, default: nil, options: "", force: :cascade do |t|
    t.string "upn", null: false
    t.string "name"
    t.string "surname"
    t.boolean "admin"
    t.datetime "updated_at"
    t.string "email"
    t.string "uid"
  end

  add_foreign_key "courses_users", "courses", name: "courses_users_ibfk_2"
  add_foreign_key "courses_users", "users", name: "courses_users_ibfk_1"
  add_foreign_key "documents", "packages", name: "documents_ibfk_1"
  add_foreign_key "packages", "archives", name: "packages_ibfk_1"
  add_foreign_key "packages", "courses", name: "packages_ibfk_2"
end
