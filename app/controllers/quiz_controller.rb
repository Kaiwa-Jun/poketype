class QuizController < ApplicationController
  def new
    @type = Type.order("RAND()").first
    @pokemons = Pokemon.where(type_id: @type.id).order("RAND()").limit(9)
  end

  def start
  end
  
  def result
  end
end
