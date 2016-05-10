require 'yaml'

module Codebreaker
  class Game

    attr_accessor :secret_code, :game_results, :hints, :turns

    HINTS = 3
    TURNS = 4

    def initialize
      @secret_code = ""
      @game_results = ""
      @hints = Array.new(HINTS) { |i| i }
      @turns = TURNS
    end

    def start
      4.times { @secret_code << rand(1..6).to_s }
    end

    def verify_guess(guess)
      @turns -= 1
      result = analyze_guess(guess)
      if result.eql? '++++'
        @game_results = 'win'
      elsif @turns == 0
        @game_results = 'lose'
      else
        @game_results = result
      end
      @game_results
    end

    def hint
      return "Hints are over" if @hints.size.eql? 0 
      index = @hints.slice!(rand(@hints.size))
      "#{index+1} number of secret code is #{@secret_code[index]}"
    end

    def save_score(name = 'unknown user')
      result = {}
      result[:name] = name
      result[:secret_code] = @secret_code
      result[:game_result] = @game_results
      result[:used_hints] = HINTS - @hints.size
      result[:used_attemps] = TURNS - @turns
      result[:date] = Time.now
      File.open('text.yml', 'a') { |f| f.write YAML.dump(result) }
    end


    private
    def analyze_guess(guess)
      result = ''
      code_split = @secret_code.split('')
      out_dublicate = code_split

      guess.split('').each_with_index do |char, index|
        if char.eql? code_split[index]
          result << "+"
        elsif out_dublicate.include? char
          result << "-"
        end

        out_dublicate[out_dublicate.index(char)] = nil unless out_dublicate.index(char).nil?
      end
      result
    end

  end
end
