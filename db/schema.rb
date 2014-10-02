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

ActiveRecord::Schema.define(version: 20140930085858) do

  create_table "courses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "tasks", force: true do |t|
    t.integer  "task_list_id"
    t.integer  "task_variant_id"
    t.integer  "index",           default: 0
    t.string   "type"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data"
    t.boolean  "done",            default: false
  end

  add_index "tasks", ["task_list_id"], name: "index_tasks_on_task_list_id"
  add_index "tasks", ["task_variant_id"], name: "index_tasks_on_task_variant_id"

end
