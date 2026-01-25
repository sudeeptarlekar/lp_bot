# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)

require 'bot/version'

Gem::Specification.new do |s|
  s.name        = 'bot'
  s.version     = Bot::VERSION
  s.summary     = 'Bot to scrap data from journey planners'
  s.description = 'Lanes&Planes Bot to scrap data from journey planners and build PORO from JSON response'
  s.authors     = ['Sudeep Tarlekar', 'Lanes&Planes']
  s.email       = 'sudeeptarlekar@gmail.com'
  s.homepage    =
    'https://rubygems.org/gems/bot'
  s.license       = 'MIT'
  s.files         = Dir['lib/**/*', 'README.md']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 3.3.0'

  s.add_dependency 'httparty', '~> 0.24.2'
end
