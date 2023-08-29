# This is a helper file for the application. It is used to define methods that can be used in the views.
# frozen_string_literal: true

###
module ApplicationHelper
  def type_id_to_name(type_id)
    type_names = {
      1 => "normal",
      2 => "fighting",
      3 => "flying",
      4 => "poison",
      5 => "ground",
      6 => "rock",
      7 => "bug",
      8 => "ghost",
      9 => "steel",
      10 => "fire",
      11 => "water",
      12 => "grass",
      13 => "electric",
      14 => "psychic",
      15 => "ice",
      16 => "dragon",
      17 => "dark",
      18 => "fairy",
      19 => "unknown",
      20 => "shadow"
    }
    type_names[type_id]
  end
end
