# すべての pokemons レコードを取得
pokemons = Pokemon.all

# 各レコードを更新
pokemons.each do |pokemon|
  # ここで 'name' を使用してAPIから新しいデータを取得
  # APIのURLを生成
  pokemon_api_url = "https://pokeapi.co/api/v2/pokemon/#{pokemon.name}"
  
  # 新しいデータを取得
  new_details = PokemonApiService.fetch_pokemon_details(pokemon_api_url)
  
  # 新しい image_url を取得
  new_image_url = new_details['sprites']['other']['official-artwork']['front_default']
  
  # レコードを更新
  pokemon.update(image_url: new_image_url)
end
