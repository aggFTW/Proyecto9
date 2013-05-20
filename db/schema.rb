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

ActiveRecord::Schema.define(:version => 20130519194630) do

  create_table "cantakes", :id => false, :force => true do |t|
    t.integer "master_exam_id"
    t.integer "user_id"
  end

  create_table "exam_definitions", :force => true do |t|
    t.integer  "master_exam_id"
    t.integer  "master_question_id"
    t.integer  "questionNum"
    t.float    "weight"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "exam_definitions", ["master_exam_id"], :name => "index_exam_definitions_on_master_exam_id"
  add_index "exam_definitions", ["master_question_id"], :name => "index_exam_definitions_on_master_question_id"

  create_table "exams", :force => true do |t|
    t.integer  "master_exam_id"
    t.integer  "user_id"
    t.string   "state"
    t.datetime "date"
    t.float    "score"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "attemptnumber"
  end

  add_index "exams", ["master_exam_id"], :name => "index_exams_on_master_exam_id"
  add_index "exams", ["user_id"], :name => "index_exams_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["user_id"], :name => "index_groups_on_user_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "master_exams", :force => true do |t|
    t.integer  "attempts"
    t.datetime "startDate"
    t.datetime "finishDate"
    t.integer  "user_id"
    t.datetime "dateCreation"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
  end

  add_index "master_exams", ["user_id"], :name => "index_master_exams_on_user_id"

  create_table "master_questions", :force => true do |t|
    t.string   "language"
    t.string   "solver"
    t.string   "randomizer"
    t.string   "inquiry"
    t.string   "concept"
    t.string   "subconcept"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "exam_id"
    t.integer  "master_question_id"
    t.integer  "questionNum"
    t.text     "values"
    t.text     "answers"
    t.string   "correctAns"
    t.string   "givenAns"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "questions", ["exam_id"], :name => "index_questions_on_exam_id"
  add_index "questions", ["master_question_id"], :name => "index_questions_on_master_question_id"

  create_table "users", :force => true do |t|
    t.string   "username",        :null => false
    t.string   "fname",           :null => false
    t.string   "lname",           :null => false
    t.integer  "utype",           :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
  end

end
