class QuizController < ApplicationController
  before_action :set_question_number

  def new
    difficulty_level = [session[:question_number], 3].min # 難易度は最大3

    # "unknown" と "shadow" タイプを除外
    excluded_types = ['unknown', 'shadow']
    @type = Type.where.not(name: excluded_types).order("RAND()").first

    # リアルポケモン6匹をランダムに選ぶ
    real_pokemons = Pokemon.where(type_id: @type.id).where('is_fake = ? OR is_fake IS NULL', false).order('RAND()').limit(6).to_a

    # フェイクポケモン3匹をランダムに選ぶ
    fake_pokemons = Pokemon.where(fake_type_id: @type.id, is_fake: true).order('RAND()').limit(3).to_a

    # フェイクポケモンが足りない場合、リアルポケモンから追加
    if fake_pokemons.count < 3
      extra_real_pokemons = Pokemon.where(type_id: @type.id).where('is_fake = ? OR is_fake IS NULL', false).where.not(id: real_pokemons.map(&:id)).order('RAND()').limit(3 - fake_pokemons.count).to_a
      real_pokemons += extra_real_pokemons
    end

    # デバッグのためのログ出力
    puts "Real Pokemons:"
    puts real_pokemons.inspect
    puts "Fake Pokemons:"
    puts fake_pokemons.inspect

    # リアルポケモンとフェイクポケモンを合わせてシャッフル
    @pokemons = (real_pokemons + fake_pokemons).shuffle

    @current_question_number = session[:question_number]
    @total_questions = 5 # 合計問題数はここで設定
  end


  def confirm
    selected_pokemons = params[:selected_pokemons].split(',').map(&:to_i)
    # 正解判定などのロジック
  end

  def start
    # クイズ開始ロジック
  end

  def result
    # 結果表示ロジック
  end

  private

  def set_question_number
    session[:question_number] ||= 0
    session[:question_number] += 1
  end
end
