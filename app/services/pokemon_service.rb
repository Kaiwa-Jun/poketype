# This service is responsible for fetching the pokemons from the API and saving them to the database.
# frozen_string_literal: true

###
class PokemonService
  def self.save_pokemons(limit = nil)
    pokemons = PokemonApiService.fetch_pokemons(limit)

    pokemons.each do |pokemon|
      details = PokemonApiService.fetch_pokemon_details(pokemon['url'])
      primary_type = Type.find_by(name: details['types'][0]['type']['name'])
      details['types'][1] ? Type.find_by(name: details['types'][1]['type']['name']).id : nil

      Pokemon.create!(
        name: details['name'],
        type: primary_type,
        secondary_type: details['types'][1] ? Type.find_by(name: details['types'][1]['type']['name']) : nil,
        image_url: details['image_url']
      )
    end
  rescue StandardError => e
    puts "エラーが発生しました: #{e.message}"
  end
end
