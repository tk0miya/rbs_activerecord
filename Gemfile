# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in rbs_activerecord.gemspec
gemspec

gem "rake", "~> 13.0"

gem "rubocop", "~> 1.69"

group :development do
  gem "rbs-inline", require: false
  gem "rspec", require: false
  gem "rspec-mocks", require: false
  gem "ruby-lsp-rspec", require: false
  gem "steep", require: false
end

group :test do
  gem "activestorage"
  gem "bcrypt"
  gem "sqlite3"
end
