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

ActiveRecord::Schema[7.1].define(version: 2023_10_29_051002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "story_id", null: false
    t.text "body"
    t.string "by"
    t.integer "time"
    t.integer "hn_id", null: false
    t.integer "parent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_comments_on_story_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title", null: false
    t.string "url"
    t.string "by"
    t.integer "hn_id", null: false
    t.integer "score"
    t.integer "time"
    t.string "kids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hn_id"], name: "index_stories_on_hn_id", unique: true
  end

  add_foreign_key "comments", "stories"
end
