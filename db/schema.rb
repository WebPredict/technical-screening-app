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

ActiveRecord::Schema.define(version: 20150304151505) do

  create_table "answered_questions", force: :cascade do |t|
    t.string   "answer"
    t.integer  "question_id"
    t.integer  "candidate_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "answered_questions", ["candidate_id"], name: "index_answered_questions_on_candidate_id"
  add_index "answered_questions", ["question_id"], name: "index_answered_questions_on_question_id"

  create_table "candidates", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "candidates", ["user_id"], name: "index_candidates_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "difficulties", force: :cascade do |t|
    t.string   "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "content"
    t.string   "answer"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "difficulty_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id"
  add_index "questions", ["difficulty_id"], name: "index_questions_on_difficulty_id"
  add_index "questions", ["user_id"], name: "index_questions_on_user_id"

  create_table "questions_tests", id: false, force: :cascade do |t|
    t.integer "test_id"
    t.integer "question_id"
  end

  add_index "questions_tests", ["question_id"], name: "index_questions_tests_on_question_id"
  add_index "questions_tests", ["test_id"], name: "index_questions_tests_on_test_id"

  create_table "test_submissions", force: :cascade do |t|
    t.string   "name"
    t.integer  "score"
    t.integer  "user_id"
    t.integer  "candidate_id"
    t.integer  "test_id"
    t.integer  "answered_questions_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "test_submissions", ["answered_questions_id"], name: "index_test_submissions_on_answered_questions_id"
  add_index "test_submissions", ["candidate_id"], name: "index_test_submissions_on_candidate_id"
  add_index "test_submissions", ["test_id"], name: "index_test_submissions_on_test_id"
  add_index "test_submissions", ["user_id"], name: "index_test_submissions_on_user_id"

  create_table "tests", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tests", ["user_id"], name: "index_tests_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
