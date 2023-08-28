# This migration creates the pokemons table
# frozen_string_literal: true

###
class CreatePokemons < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.references :type, null: false, foreign_key: true
      t.string :image_url
      t.integer :difficulty_level
      t.boolean :is_fake
      t.bigint :fake_type_id

      t.timestamps
    end
    add_foreign_key :pokemons, :types, column: :fake_type_id
  end
end
