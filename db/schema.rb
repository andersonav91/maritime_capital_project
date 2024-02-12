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

ActiveRecord::Schema[7.1].define(version: 2024_02_12_004015) do
  create_table "trades", force: :cascade do |t|
    t.date "trade_date"
    t.datetime "trade_date_time"
    t.string "row_id"
    t.string "security_id"
    t.string "security_name"
    t.float "coupon_rate"
    t.date "maturity_date"
    t.integer "transaction_type_id", null: false
    t.float "trade_price"
    t.integer "trade_yield"
    t.integer "par_traded"
    t.float "notional_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_type_id"], name: "index_trades_on_transaction_type_id"
  end

  create_table "transaction_types", force: :cascade do |t|
    t.string "code", limit: 2
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "trades", "transaction_types"
end
