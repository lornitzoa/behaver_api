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

ActiveRecord::Schema.define(version: 2019_03_08_183118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assigned_behaviors", id: false, force: :cascade do |t|
    t.integer "child_id"
    t.integer "behavior_id"
    t.integer "points"
  end

  create_table "assigned_tasks", id: false, force: :cascade do |t|
    t.integer "child_id"
    t.integer "task_id"
    t.string "frequency", limit: 20
    t.string "time_of_day", limit: 6
    t.integer "points"
    t.boolean "required"
    t.boolean "completed"
  end

  create_table "behaviors", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "behavior_name", limit: 30
    t.string "targeted_for", limit: 16
  end

  create_table "members", id: false, force: :cascade do |t|
    t.serial "member_id", null: false
    t.string "name", limit: 30
    t.string "role", limit: 30
    t.integer "pin"
    t.integer "family_id"
  end

  create_table "reinforcements", id: false, force: :cascade do |t|
    t.integer "id"
    t.string "reinforcement", limit: 30
  end

  create_table "reinforcements_available_to", id: false, force: :cascade do |t|
    t.integer "child_id"
    t.integer "reinforcement_id"
    t.integer "worth"
    t.string "availability_freq", limit: 20
    t.boolean "available"
  end

  create_table "scores", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "behavior_points"
    t.integer "tasks_completed"
    t.integer "task_points"
    t.integer "stashed_cash"
  end

  create_table "tasks", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "task", limit: 30
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
