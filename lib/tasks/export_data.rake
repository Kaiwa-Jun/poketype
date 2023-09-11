namespace :db do
  desc "Export data from development database to seeds.rb"
  task export_data: :environment do
    File.open("db/seeds.rb", "w") do |file|
      # Export Type model
      file.puts "Type.delete_all"
      Type.all.each do |type|
        file.puts "Type.create!(#{type.attributes.except('id', 'created_at', 'updated_at').inspect})"
      end

      # Export Pokemon model
      file.puts "Pokemon.delete_all"
      Pokemon.all.each do |pokemon|
        file.puts "Pokemon.create!(#{pokemon.attributes.except('id', 'created_at', 'updated_at').inspect})"
      end

      # Export PokemonType model
      file.puts "PokemonType.delete_all"
      PokemonType.all.each do |pokemon_type|
        file.puts "PokemonType.create!(#{pokemon_type.attributes.except('id', 'created_at', 'updated_at').inspect})"
      end
    end
  end
end
