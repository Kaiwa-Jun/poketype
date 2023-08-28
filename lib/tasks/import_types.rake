# frozen_string_literal: true

namespace :import do
  desc 'Import types from PokeAPI'
  task types: :environment do
    types = PokemonApiService.fetch_types
    types.each do |type|
      Type.find_or_create_by(name: type['name'])
    end
    puts "Imported #{types.count} types."
  end
end
