require 'rest-client'
require 'json'

class PokemonApiService
  BASE_URL = 'https://pokeapi.co/api/v2/'

  def self.fetch_pokemons(limit = 10)
    response = RestClient.get("#{BASE_URL}pokemon?limit=#{limit}")
    JSON.parse(response.body)['results']
  end
end


