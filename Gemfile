# frozen_string_literal: true

source "https://rubygems.org", cooldown: 7

# Specify your gem's dependencies in rbs_activerecord.gemspec
gemspec

gem "rake", "~> 13.4"

gem "rubocop", "~> 1.88"
gem "rubocop-numbered-params"
gem "rubocop-rake"
gem "rubocop-rbs_inline"
gem "rubocop-rspec"

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
