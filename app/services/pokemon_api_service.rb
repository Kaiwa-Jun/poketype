require 'rest-client'
require 'json'

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

  def self.fetch_pokemon_details(pokemon_url)
    response = RestClient.get(pokemon_url)
    details = JSON.parse(response.body)
    image_url = details['sprites']['front_default']
    details.merge('image_url' => image_url)
  end
end

