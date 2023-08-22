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

ActiveRecord::Schema[7.0].define(version: 2023_08_22_175111) do
  create_table "pokemon_types", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "pokemon_id", null: false
    t.bigint "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id"], name: "index_pokemon_types_on_pokemon_id"
    t.index ["type_id"], name: "index_pokemon_types_on_type_id"
  end

  create_table "pokemons", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.bigint "type_id", null: false
    t.string "image_url"
    t.integer "difficulty_level"
    t.boolean "is_fake"
    t.bigint "fake_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "secondary_type_id"
    t.index ["fake_type_id"], name: "fk_rails_6c8761dfff"
    t.index ["secondary_type_id"], name: "index_pokemons_on_secondary_type_id"
    t.index ["type_id"], name: "index_pokemons_on_type_id"
  end

  create_table "types", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pokemon_types", "pokemons"
  add_foreign_key "pokemon_types", "types"
  add_foreign_key "pokemons", "types"
  add_foreign_key "pokemons", "types", column: "fake_type_id"
  add_foreign_key "pokemons", "types", column: "secondary_type_id"
end
