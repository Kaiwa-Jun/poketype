# This migration adds a reference to the secondary type of a pokemon
# frozen_string_literal: true

###
class AddSecondaryTypeToPokemons < ActiveRecord::Migration[7.0]
  def change
    add_reference :pokemons, :secondary_type, foreign_key: { to_table: :types }
  end
end
