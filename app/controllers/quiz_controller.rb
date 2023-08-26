class QuizController < ApplicationController
  before_action :set_question_number

  def new
    @total_questions = 5
    if session[:question_number] > @total_questions
      redirect_to quiz_result_path and return
    end

    difficulty_level = [session[:question_number], 3].min

    excluded_types = ['unknown', 'shadow']
    @type = Type.where.not(name: excluded_types).order("RAND()").first

    real_pokemons = Pokemon.where(type_id: @type.id).where('is_fake = ? OR is_fake IS NULL', false).order('RAND()').limit(6).to_a
    fake_pokemons = Pokemon.where(fake_type_id: @type.id, is_fake: true).order('RAND()').limit(3).to_a

    if fake_pokemons.count < 3
      extra_real_pokemons = Pokemon.where(type_id: @type.id).where('is_fake = ? OR is_fake IS NULL', false).where.not(id: real_pokemons.map(&:id)).order('RAND()').limit(3 - fake_pokemons.count).to_a
      real_pokemons += extra_real_pokemons
    end

    @pokemons = (real_pokemons + fake_pokemons).shuffle
    session[:pokemons] = @pokemons.map { |pokemon| pokemon.id }
    session[:correct_pokemons] = real_pokemons.map { |pokemon| pokemon.id }

    @current_question_number = session[:question_number]
    @total_questions = 5
    session[:type_id] = @type.id
    session[:type_name] = @type.name
  end

def confirm
  @total_questions = 5
  selected_pokemons_indexes = params[:selected_pokemons].split(',').map(&:to_i)
  selected_pokemons_ids = selected_pokemons_indexes.map { |index| session[:pokemons][index.to_i] }
  correct_type_id = session[:type_id]  # 問題で指定されたタイプID

  # 選択されたポケモンのtype_idを取得
  selected_pokemons_type_ids = Pokemon.where(id: selected_pokemons_ids).pluck(:type_id)

  # 選択された全てのポケモンのtype_idが問題で指定されたタイプIDと一致するか確認
  is_correct = selected_pokemons_type_ids.all? { |type_id| type_id == correct_type_id }

  session[:results] << { question: session[:type_name], correct: is_correct, correct_pokemons: session[:correct_pokemons], all_pokemons: session[:pokemons] }

  if session[:question_number] >= @total_questions
    redirect_to quiz_result_path
  else
    redirect_to quiz_new_path
  end
end


  def start
    session[:question_number] = 0
    session[:results] = [] 
    redirect_to action: :new
  end

def result
  @total_questions = 5
  puts "Debugging session[:results]:"
  puts session[:results].inspect
  puts "Debugging the first all_pokemons:"
  puts session[:results].first[:all_pokemons] # 最初の問題の all_pokemons の内容を出力
end


  def restart
    session[:question_number] = 0
    session[:results] = []
    redirect_to quiz_new_path
  end

  private

  def set_question_number
    session[:question_number] ||= 0
    session[:question_number] += 1 if action_name == 'new'
    session[:results] ||= []
  end
end
