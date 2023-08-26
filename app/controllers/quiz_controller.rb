class QuizController < ApplicationController
  before_action :set_question_number

def new
  @total_questions = 5
  if session[:question_number] > @total_questions
    redirect_to quiz_result_path and return
  end

  excluded_types = ['unknown', 'shadow']
  @type = Type.where.not(name: excluded_types).order("RAND()").first

  # @typeがnilでないことを確認
  if @type.nil?
    redirect_to some_error_page_path and return
  end

  # 質問数に基づいてフェイクポケモン、同タイプポケモン、異なるタイプのポケモンの数を決定
  fake_pokemon_count, same_type_pokemon_count, different_type_pokemon_count = case session[:question_number]
  when 1
    [0, 9, 0]
  when 2
    [0, 6, 3]
  when 3
    [1, 6, 2]
  when 4
    [2, 5, 2]
  when 5
    [3, 6, 0]
  else
    [0, 0, 0]  # Default case, you can handle this differently if needed
  end

  # fake_pokemons の選択に fake_type_id と image_url を考慮
  fake_pokemons = Pokemon.where(fake_type_id: @type.id, is_fake: true)
                          .where('image_url IS NOT NULL')
                          .order('RAND()').limit(fake_pokemon_count).to_a

  # 同タイプのreal_pokemons の数を調整
  real_pokemons_same_type = Pokemon.where('(type_id = ? OR secondary_type_id = ?) AND image_url IS NOT NULL', @type.id, @type.id)
                                   .where('fake_type_id IS NULL OR fake_type_id != ?', @type.id)
                                   .order('RAND()').limit(same_type_pokemon_count).to_a

  # 異なるタイプのreal_pokemons の数を調整
  real_pokemons_diff_type = Pokemon.where.not('(type_id = ? OR secondary_type_id = ?)', @type.id, @type.id)
                                   .where('fake_type_id IS NULL OR fake_type_id != ?', @type.id)
                                   .where('image_url IS NOT NULL')
                                   .order('RAND()').limit(different_type_pokemon_count).to_a

  @pokemons = (real_pokemons_same_type + real_pokemons_diff_type + fake_pokemons).shuffle

  # デバッグ出力
  puts "Debugging in new action:"
  puts "Selected Type: #{@type.name}"
  @pokemons.each do |pokemon|
    puts "Pokemon Name: #{pokemon.name}, Type ID: #{pokemon.type_id}, Secondary Type ID: #{pokemon.secondary_type_id}, Fake Type ID: #{pokemon.fake_type_id}, Image URL: #{pokemon.image_url}"
  end

  session[:pokemons] = @pokemons.map { |pokemon| pokemon.id }
  session[:correct_pokemons] = real_pokemons_same_type.map { |pokemon| pokemon.id }

  @current_question_number = session[:question_number]
  @total_questions = 5
  session[:type_id] = @type.id
  session[:type_name] = @type.name

  # その他のデバッグ出力
  puts "Debugging in new action:"
  puts "session[:pokemons]: #{session[:pokemons].inspect}"
  puts "session[:correct_pokemons]: #{session[:correct_pokemons].inspect}"
  puts "session[:type_id]: #{session[:type_id]}"
  # fraxureのID（例えば、fraxureがID 1000だとする）
  fraxure_id = 1000 # 実際のIDに変更してください
  puts "Is fraxure in correct_pokemons?: #{session[:correct_pokemons].include?(fraxure_id)}"
end



def confirm
  @total_questions = 5
  selected_pokemons_indexes = params[:selected_pokemons].split(',').map(&:to_i)
  selected_pokemons_ids = selected_pokemons_indexes.map { |index| session[:pokemons][index.to_i] }
  correct_type_id = session[:type_id]  # 問題で指定されたタイプID

    # 選択されたポケモンのtype_id, secondary_type_id, そして fake_type_id を取得
    selected_pokemons_types = Pokemon.where(id: selected_pokemons_ids).pluck(:type_id, :secondary_type_id, :fake_type_id)

# 選択された全てのポケモンが、問題で指定されたタイプIDと一致するか確認
is_correct = selected_pokemons_types.all? do |type_id, secondary_type_id, fake_type_id|
  type_id == correct_type_id || secondary_type_id == correct_type_id || fake_type_id == correct_type_id
end


  session[:results] << { question: session[:type_name], correct: is_correct, correct_pokemons: session[:correct_pokemons], all_pokemons: session[:pokemons] }

  if session[:question_number] >= @total_questions
    redirect_to quiz_result_path
  else
    redirect_to quiz_new_path
  end

  # デバッグ出力
  puts "Debugging in confirm action:"
  puts "session[:pokemons]: #{session[:pokemons].inspect}"
  puts "session[:correct_pokemons]: #{session[:correct_pokemons].inspect}"
  puts "session[:type_id]: #{session[:type_id]}"
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
