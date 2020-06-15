require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # @@score = 0

  def new
    alphabet = ('A'..'Z').to_a
    @grid = []
    10.times { @grid.append(alphabet[rand(0...alphabet.length)]) }
    print @grid
  end

  def score
    @grid = params[:grid].split
    @attempt = params[:word]
    check_english = english_word(@attempt)
    @result = { english?: check_english["found"], grid?: in_grid?(@attempt, @grid) }
    # @@score += check["length"] if in_grid?(@attempt, @grid) && check["found"]
  end

  def english_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/" + attempt
    check_serialized = open(url).read
    JSON.parse(check_serialized)
  end

  def in_grid?(attempt, grid)
    attempt_a = attempt.upcase.split("")
    attempt_a.each do |letter|
      print letter
      if grid.index(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
      print grid
    end
    true
  end
end
