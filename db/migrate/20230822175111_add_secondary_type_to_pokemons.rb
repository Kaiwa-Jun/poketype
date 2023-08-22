class AddSecondaryTypeToPokemons < ActiveRecord::Migration[7.0]
  def change
    add_reference :pokemons, :secondary_type, foreign_key: { to_table: :types }
  end
end

