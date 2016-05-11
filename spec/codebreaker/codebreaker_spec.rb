require 'spec_helper'

module Codebreaker
  RSpec.describe App do
    let(:game) { Game.new }
    let(:app) { App.new }
    
    before (:each) do
      allow(app).to receive(:gets).and_return('1234')
    end

    context "when start play" do
      it "send greetings text" do
        expect{ app.play }.to output(/Let's start to play!/).to_stdout
      end

      it "request for a guess" do
        expect{ app.play }.to output(/Type four numbers between 1 and 6/).to_stdout
      end     
    end


    context "when restart game" do
      it 'offer for play again' do
        expect { app.play_again }.to output(/Would you like play again?/).to_stdout
      end

      it "new greetings if user approve for play again" do
        allow(app).to receive(:gets).and_return('y','Let\'s start to play!')
        expect { app.play_again }.to output(/Let's start to play!/).to_stdout
      end
    end


    context "when save a game" do
      it 'offer to save result' do
        expect { app.play }.to output(/Would you like save result?/).to_stdout
      end

      it 'ask name if user approve to save result' do
        allow(app).to receive(:gets).and_return('Kiril')
        expect { app.save_game('y') }.to output(/Enter your name/).to_stdout
      end
    end


    context "when user typed answer for question" do
      it "request for a hint (typed 'h') " do
        allow(app).to receive(:gets).and_return('h', 'false')
        game = app.instance_variable_get(:@game)
        allow(game).to receive(:hint).and_return('one of the numbers in secret code is 1')
        expect { app._matcher }.to output(/one of the numbers in secret code is 1/).to_stdout
      end

      it 'return message if user enter invalid data' do
        allow(app).to receive(:gets).and_return('43lo', '1234')
        expect { app.play }.to output(/You typed invalid data/).to_stdout
      end

      it "analize guess if type a valid data" do
        allow(app).to receive(:analize_guess).with('1234').and_return('You win! Would you like save result?')
        expect(app._matcher('1234')).to eq("You win! Would you like save result?")
      end
    end
  end
end