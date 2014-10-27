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

ActiveRecord::Schema.define(version: 20141027152101) do

  create_table "courses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_assignments", force: true do |t|
    t.integer  "student_id"
    t.integer  "task_variant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_assignments", ["student_id"], name: "index_student_assignments_on_student_id"
  add_index "student_assignments", ["task_variant_id"], name: "index_student_assignments_on_task_variant_id"

  create_table "student_task_attempts", force: true do |t|
    t.integer  "student_id"
    t.integer  "task_id"
    t.boolean  "done",          default: false
    t.string   "error_message"
    t.string   "type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_task_attempts", ["student_id"], name: "index_student_task_attempts_on_student_id"
  add_index "student_task_attempts", ["task_id"], name: "index_student_task_attempts_on_task_id"

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "students", ["login"], name: "index_students_on_login", unique: true

  create_table "task_lists", force: true do |t|
    t.integer  "index",      default: 0
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_variants", force: true do |t|
    t.integer  "index",       default: 0
    t.text     "description"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.text     "data"
  end

  create_table "tasks", force: true do |t|
    t.integer  "task_list_id"
    t.integer  "task_variant_id"
    t.integer  "index",           default: 0
    t.string   "type"
    t.text     "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "data"
    t.string   "title"
  end

  add_index "tasks", ["task_list_id"], name: "index_tasks_on_task_list_id"
  add_index "tasks", ["task_variant_id"], name: "index_tasks_on_task_variant_id"

end
