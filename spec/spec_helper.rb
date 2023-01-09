# frozen_string_literal: true

require 'pry-byebug'

require 'simplecov'

if ENV['CI']
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'

require_relative 'app/config/environment'
require_relative '../lib/r18n-rails'

require 'rspec/rails'
