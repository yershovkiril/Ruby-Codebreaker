$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
require 'codebreaker/codebreaker'
require 'codebreaker/game'
require 'simplecov'
SimpleCov.start