# Type model
# This model is responsible for storing the types of pokemons.
# frozen_string_literal: true

###
class Type < ApplicationRecord
  has_many :pokemons
  has_many :secondary_pokemons, class_name: 'Pokemon', foreign_key: 'secondary_type_id'
  has_many :fake_pokemons, class_name: 'Pokemon', foreign_key: 'fake_type_id'
end
