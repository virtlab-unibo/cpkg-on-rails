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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120828221401) do

  create_table "archives", :force => true do |t|
    t.string "uri",          :limit => 250
    t.string "distribution", :limit => 50
    t.string "component",    :limit => 50
    t.string "arch",         :limit => 20
  end

  create_table "changelogs", :force => true do |t|
    t.integer "package_id",  :null => false
    t.integer "user_id",     :null => false
    t.string  "version"
    t.text    "description"
    t.string  "date",  :null => false
    t.string  "urgency",  :null => false
    t.string  "distributions",  :null => false
  end

  add_index "changelogs", ["package_id"], :name => "index_package_id_on_changelogs"
  add_index "changelogs", ["user_id"], :name => "index_user_id_on_changelogs"

  create_table "courses", :force => true do |t|
    t.string  "name"
    t.integer "degree_id"
    t.text    "description"
    t.integer "year"
    t.string  "abbr",        :limit => 10
  end

  create_table "courses_users", :id => false, :force => true do |t|
    t.integer "user_id",                       :null => false
    t.integer "course_id",                     :null => false
    t.boolean "owner_flag", :default => false
  end

  add_index "courses_users", ["course_id"], :name => "index_course_id_on_courses_users"
  add_index "courses_users", ["user_id"], :name => "index_user_id_on_courses_users"

  create_table "degrees", :force => true do |t|
    t.string "code", :limit => 6, :null => false
    t.string "name",              :null => false
  end

  create_table "documents", :force => true do |t|
    t.integer  "package_id",                         :null => false
    t.string   "name",                :limit => 200
    t.text     "description"
    t.datetime "created_at"
    t.string   "attach_file_name",    :limit => 250
    t.string   "attach_content_type", :limit => 100
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
  end

  add_index "documents", ["package_id"], :name => "index_package_id_on_documents"

  create_table "invitations", :force => true do |t|
    t.string "email",                     :null => false
    t.string "uuid",       :limit => 200, :null => false
    t.date   "expiration"
  end

  create_table "packages", :force => true do |t|
    t.integer "archive_id"
    t.integer "course_id"
    t.string  "name",        :null => false
    t.string  "homepage"
    t.string  "short_description"
    t.text    "long_description"
    t.text    "depends"
    t.string  "version"
    t.string  "filename"
  end

  add_index "packages", ["archive_id"], :name => "index_archive_id_on_packages"
  add_index "packages", ["course_id"], :name => "index_course_id_on_packages"
  add_index "packages", ["name"], :name => "index_name_on_packages"

  create_table "users", :force => true do |t|
    t.string   "email",        :null => false
    t.string   "name"
    t.string   "surname"
    t.boolean  "admin"
    t.string   :encrypted_password, :null => false, :default => ""    
    t.string   :provider
    t.string   :uid
    t.datetime :remember_created_at
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_email_on_users"

  create_table :scripts, :force => true do |t| 
    t.integer  "package_id",          :null =>     false
    t.string   "name",                :null =>     false
    t.string   "stype",                :null =>    false
    t.datetime "created_at"
    t.string   "attach_file_name",    :limit => 250 
    t.string   "attach_content_type", :limit => 100 
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
  end

end
