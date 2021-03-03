# frozen_string_literal: true

include :bundler, static: true

require 'gem_toys'
expand GemToys::Template,
  changelog_file_name: 'ChangeLog.md',
  version_file_path: 'lib/r18n-rails/version.rb',
  unreleased_title: '## Unreleased',
  version_tag_prefix: ''

alias_tool :g, :gem

tool :console do
  def run
    require_relative 'lib/r18n-rails'

    require 'pry'
    Pry.start
  end
end

alias_tool :c, :console
