# frozen_string_literal: true

require 'rest-client'
require 'json'

# PokemonApiService is responsible for fetching data from the PokeAPI.
class PokemonApiService
  BASE_URL = 'https://pokeapi.co/api/v2/'

  def self.fetch_pokemons(limit = nil)
    url = "#{BASE_URL}pokemon"
    url += "?limit=#{limit}" if limit
    response = RestClient.get(url)
    JSON.parse(response.body)['results']
  end

  def self.fetch_types
    response = RestClient.get("#{BASE_URL}type/")
    JSON.parse(response.body)['results']
  end

  def self.fetch_pokemon_details(pokemon_api_url)
    response = RestClient.get(pokemon_api_url)
    details = JSON.parse(response.body)
    image_url = details['sprites']['other']['official-artwork']['front_default']
    details.merge('image_url' => image_url)
  end
end
