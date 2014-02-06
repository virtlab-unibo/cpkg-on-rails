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

ActiveRecord::Schema.define(version: 20120828221401) do

  create_table "archives", force: true do |t|
    t.string  "uri",          limit: 250
    t.string  "distribution", limit: 50
    t.string  "component",    limit: 50
    t.string  "arch",         limit: 20
    t.boolean "global"
  end

  create_table "changelogs", force: true do |t|
    t.integer "package_id",                null: false
    t.integer "user_id",                   null: false
    t.string  "version"
    t.text    "description"
    t.date    "date"
    t.string  "urgency",       limit: 100
    t.string  "distributions", limit: 100
  end

  add_index "changelogs", ["package_id"], name: "package_id", using: :btree
  add_index "changelogs", ["user_id"], name: "user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string  "name"
    t.integer "degree_id"
    t.text    "description"
    t.integer "year"
    t.string  "abbr",        limit: 10
  end

  create_table "courses_users", id: false, force: true do |t|
    t.integer "user_id",   null: false
    t.integer "course_id", null: false
  end

  add_index "courses_users", ["course_id"], name: "course_id", using: :btree

  create_table "degrees", force: true do |t|
    t.string "code", limit: 6, null: false
    t.string "name",           null: false
  end

  create_table "documents", force: true do |t|
    t.integer  "package_id",                      null: false
    t.string   "name",                limit: 200
    t.text     "description"
    t.datetime "created_at"
    t.string   "attach_file_name",    limit: 250
    t.string   "attach_content_type", limit: 100
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.text     "install_path"
  end


  create_table "invitations", force: true do |t|
    t.string "email",                  null: false
    t.string "uuid",       limit: 200, null: false
    t.date   "expiration"
  end

  create_table "packages", force: true do |t|
    t.integer "archive_id"
    t.integer "course_id"
    t.string  "name",              null: false
    t.string  "short_description"
    t.string  "homepage"
    t.text    "long_description"
    t.text    "depends"
    t.string  "version"
    t.text    "filename"
  end

  add_index "packages", ["archive_id"], name: "archive_id", using: :btree
  add_index "packages", ["name"], name: "package_name", using: :btree

  create_table "scripts", force: true do |t|
    t.integer  "package_id"
    t.string   "name"
    t.string   "stype",               limit: 20
    t.datetime "created_at"
    t.string   "attach_file_name"
    t.datetime "attach_updated_at"
    t.string   "attach_content_type", limit: 100
    t.integer  "attach_file_size"
  end

  create_table "users", force: true do |t|
    t.string   "upn",        null: false
    t.string   "name"
    t.string   "surname"
    t.boolean  "admin"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "uid"
  end

  add_index "users", ["upn"], name: "index_upn_on_users", using: :btree

end
