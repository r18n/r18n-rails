# frozen_string_literal: true

require 'pry-byebug'

require 'simplecov'
SimpleCov.start

if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['RAILS_ENV'] ||= 'test'

require_relative 'app/config/environment'
require_relative '../lib/r18n-rails'

require 'rspec/rails'
