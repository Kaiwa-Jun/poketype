class PokemonService
  def self.save_pokemons(limit = nil)
    begin
      pokemons = PokemonApiService.fetch_pokemons(limit)

      pokemons.each do |pokemon|
        details = PokemonApiService.fetch_pokemon_details(pokemon['url'])
        primary_type = Type.find_by(name: details['types'][0]['type']['name'])
        secondary_type_id = details['types'][1] ? Type.find_by(name: details['types'][1]['type']['name']).id : nil

        Pokemon.create!(
          name: details['name'],
          type: primary_type,
          secondary_type: details['types'][1] ? Type.find_by(name: details['types'][1]['type']['name']) : nil,
          image_url: details['image_url'] 
        # 他の必要な属性もここで設定することができます
        )
      end
    rescue => e
      puts "エラーが発生しました: #{e.message}"
    end
  end
end

