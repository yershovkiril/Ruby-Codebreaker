require_relative "game"

module Codebreaker
  class App
    
    def initialize
      @game = Game.new
      @game.start
    end

    def play
      puts "Let's start to play!"
      puts "Type four numbers between 1 and 6 (use 'h' for hint)"
      _matcher
    end

    def _matcher(answer = gets.chomp)
      if answer.match /^[1-6]{4}$/
        analize_guess(answer)
      elsif answer.match /^h/
        puts @game.hint
        _matcher
      else
        puts "You typed invalid data"
        play_again
      end
    end

    def analize_guess(answer)
      result = @game.verify_guess(answer)
      if !['lose', 'win'].include? result
        puts "Your guess is wrong (#{result}), try again...(you have still #{@game.send(:turns)} attemps)" 
        _matcher
      else
        puts "You #{result}! Would you like save result? (y/n)"
        save_game(gets.chomp)
        play_again
      end
    end

    def save_game(answer)
      return unless answer.match /^y/
      puts "Enter your name"
      @game.save_score(gets.chomp)
    end

    def play_again
      puts "Would you like play again? (y/n)"
      return unless gets.chomp.match /^y/
      @game = Game.new
      @game.start
      self.play
    end
  end
end
