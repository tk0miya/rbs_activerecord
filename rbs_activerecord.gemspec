# frozen_string_literal: true

require_relative "lib/rbs_activerecord/version"

Gem::Specification.new do |spec|
  spec.name = "rbs_activerecord"
  spec.version = RbsActiverecord::VERSION
  spec.authors = ["Takeshi KOMIYA"]
  spec.email = ["i.tkomiya@gmail.com"]

  spec.summary = "A RBS files generator for activerecord gem"
  spec.description = "A RBS files generator for activerecord gem"
  spec.homepage = "https://github.com/tk0miya/rbs_activerecord"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "prism"
  spec.add_dependency "railties"
end
