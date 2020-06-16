require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    session[:score] ||= 0
    alphabet = ('A'..'Z').to_a
    @grid = []
    10.times { @grid.append(alphabet[rand(0...alphabet.length)]) }
  end

  def score
    @grid = params[:grid].split
    @attempt = params[:word]
    check_english = english_word(@attempt)
    @result = { english?: check_english["found"], grid?: in_grid?(@attempt, @grid) }
    if in_grid?(@attempt, @grid) && check_english["found"]
      session[:score] += check_english["length"]
    end
    print "score "
    print session[:score]
  end

  private

  def english_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/" + attempt
    check_serialized = open(url).read
    JSON.parse(check_serialized)
  end

  def in_grid?(attempt, grid)
    attempt_a = attempt.upcase.split("")
    attempt_a.each do |letter|
      # print letter
      if grid.index(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
      # print grid
    end
    true
  end
end
