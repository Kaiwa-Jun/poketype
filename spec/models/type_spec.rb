require 'rails_helper'

RSpec.describe Type, type: :model do
  it { should have_many(:pokemons) }
  it { should have_many(:secondary_pokemons).class_name('Pokemon').with_foreign_key('secondary_type_id') }
  it { should have_many(:fake_pokemons).class_name('Pokemon').with_foreign_key('fake_type_id') }
end