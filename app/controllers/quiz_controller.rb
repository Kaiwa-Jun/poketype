class QuizController < ApplicationController
  before_action :set_question_number

def new
  @total_questions = 5
  if session[:question_number] > @total_questions
    redirect_to quiz_result_path and return
  end

  excluded_types = ['unknown', 'shadow']
  @type = Type.where.not(name: excluded_types).order("RAND()").first

  if @type.nil?
    redirect_to some_error_page_path and return
  end

  # 質問数に基づいてフェイクポケモン、同タイプ、異なるタイプの数を決定
  case session[:question_number]
  when 1
    fake_count, same_type_count, diff_type_count = 0, 9, 0
  when 2
    fake_count, same_type_count, diff_type_count = 0, 6, 3
  when 3
    fake_count, same_type_count, diff_type_count = 1, 6, 2
  when 4
    fake_count, same_type_count, diff_type_count = 2, 5, 2
  when 5
    fake_count, same_type_count, diff_type_count = 3, 6, 0
  else
    fake_count, same_type_count, diff_type_count = 0, 0, 0
  end

# ポケモンの選出
fake_pokemons = Pokemon.where(fake_type_id: @type.id, is_fake: true).where("image_url IS NOT NULL").order('RAND()').limit(fake_count).to_a
same_type_pokemons = Pokemon.where('(type_id = ? OR secondary_type_id = ?)', @type.id, @type.id).where.not(id: fake_pokemons.map(&:id)).where("image_url IS NOT NULL").order('RAND()').limit(same_type_count).to_a
diff_type_pokemons = Pokemon.where.not('(type_id = ? OR secondary_type_id = ?)', @type.id, @type.id).where.not(id: fake_pokemons.map(&:id) + same_type_pokemons.map(&:id)).where("image_url IS NOT NULL").order('RAND()').limit(diff_type_count).to_a


  # 出題ポケモンの補充
  total_needed = fake_count + same_type_count + diff_type_count
  total_have = fake_pokemons.size + same_type_pokemons.size + diff_type_pokemons.size
  if total_needed > total_have
    additional_pokemons = Pokemon.where.not(id: fake_pokemons.map(&:id) + same_type_pokemons.map(&:id) + diff_type_pokemons.map(&:id)).order('RAND()').limit(total_needed - total_have).to_a
    same_type_pokemons += additional_pokemons
  end

  @pokemons = (fake_pokemons + same_type_pokemons + diff_type_pokemons).shuffle


  # デバッグ出力
  puts "Debugging in new action:"
  puts "Selected Type: #{@type.name}"
  @pokemons.each do |pokemon|
    puts "Pokemon Name: #{pokemon.name}, Type ID: #{pokemon.type_id}, Secondary Type ID: #{pokemon.secondary_type_id}, Fake Type ID: #{pokemon.fake_type_id}, Image URL: #{pokemon.image_url}"
  end

  session[:pokemons] = @pokemons.map { |pokemon| pokemon.id }
  session[:correct_pokemons] = same_type_pokemons.map { |pokemon| pokemon.id }


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
is_correct = (selected_pokemons_ids.sort == session[:correct_pokemons].sort)

# confirmアクション内
puts "Debugging in confirm action: Before updating session[:results]"
puts "session[:results]: #{session[:results].inspect}"

# session[:results] の更新
session[:results] << { question: session[:type_name], correct: is_correct, correct_pokemons: session[:correct_pokemons], all_pokemons: session[:pokemons] }

puts "Debugging in confirm action: After updating session[:results]"
puts "session[:results]: #{session[:results].inspect}"


  if session[:question_number] >= @total_questions
    redirect_to quiz_result_path
  else
    redirect_to quiz_new_path
  end

  # デバッグ出力
puts "Debugging in confirm action:"
puts "Selected Pokemons IDs: #{selected_pokemons_ids.inspect}"
puts "Correct Pokemons IDs: #{session[:correct_pokemons].inspect}"
puts "Is this question correct?: #{is_correct}"
end



  def start
    session[:question_number] = 0
    session[:results] = []
    redirect_to action: :new
  end

def result
  @total_questions = 5
    correct_count = 0

# resultアクション内で
puts "Debugging in result action: Before calculating correct_count"
puts "Initial correct_count: #{correct_count}"

puts "Debugging: Inspecting session[:results]"
puts session[:results].inspect

session[:results].each do |result|
  puts "Debugging in result action: Inspecting each result"
  puts "Result object: #{result.inspect}"
  puts "Result has key 'correct'? #{result.key?('correct')}"
  puts "Result correct?: #{result['correct']}"
  if result['correct']
    correct_count += 1
    puts "Debugging in result action: Incremented correct_count to #{correct_count}"
  end
end

puts "Debugging in result action: Final correct_count"
puts "Correct Count: #{correct_count}"






  @correct_count = correct_count

  # 結果画面で表示するための変数
  @correct_percentage = (@correct_count.to_f / @total_questions) * 100

  puts "Total correct count: #{@correct_count}"
puts "Debugging in result action:"
puts "Total Questions: #{@total_questions}"
puts "Session Results: #{session[:results].inspect}"
puts "Correct Count: #{@correct_count}"
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
