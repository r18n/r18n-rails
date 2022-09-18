# frozen_string_literal: true

require_relative 'lib/r18n-rails/version'

Gem::Specification.new do |s|
  s.name     = 'r18n-rails'
  s.version  = R18n::Rails::VERSION

  s.summary = 'R18n for Rails'
  s.description = <<-DESC
    Out-of-box R18n support for Ruby on Rails.
    It is just a wrapper for R18n Rails API and R18n core libraries.
    R18n has nice Ruby-style syntax, filters, flexible locales, custom loaders,
    translation support for any classes, time and number localization, several
    user language support, agnostic core package with out-of-box support for
    Rails, Sinatra and desktop applications.
  DESC

  s.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE', 'ChangeLog.md']
  s.extra_rdoc_files = ['README.md', 'LICENSE']

  s.authors  = ['Andrey Sitnik', 'Alexander Popov']
  s.email    = ['andrey@sitnik.ru', 'alex.wayfer@gmail.com']
  s.license  = 'LGPL-3.0'

  github_uri = "https://github.com/r18n/#{s.name}"

  s.homepage = github_uri

  s.metadata = {
    'rubygems_mfa_required' => 'true',
    'bug_tracker_uri' => "#{github_uri}/issues",
    'changelog_uri' => "#{github_uri}/blob/#{s.version}/ChangeLog.md",
    'documentation_uri' => "http://www.rubydoc.info/gems/#{s.name}/#{s.version}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => github_uri
  }

  s.required_ruby_version = '>= 2.7', '< 4'

  ## Without it there are fails for Ruby >= 3.1
  ## https://www.ruby-lang.org/en/news/2021/12/25/ruby-3-1-0-released/
  s.add_dependency 'net-smtp', '~> 0.3.1'

  s.add_dependency 'r18n-rails-api', '~> 5.0'
  s.add_dependency 'rails', '>= 5.0', '< 8'

  s.add_development_dependency 'pry-byebug', '~> 3.9'

  s.add_development_dependency 'gem_toys', '~> 0.12.1'
  s.add_development_dependency 'toys', '~> 0.13.0'

  s.add_development_dependency 'rubocop', '~> 1.36.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.9'
  s.add_development_dependency 'rubocop-rails', '~> 2.16.1'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'

  s.add_development_dependency 'codecov', '~> 0.6.0'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'rspec-rails', '~> 5.0'
  s.add_development_dependency 'simplecov', '~> 0.21.0'
  s.add_development_dependency 'sqlite3', '~> 1.4'
end
