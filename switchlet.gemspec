# frozen_string_literal: true

require_relative "lib/switchlet/version"

Gem::Specification.new do |spec|
  spec.name = "switchlet"
  spec.version = Switchlet::VERSION
  spec.authors = ["komagata"]
  spec.email = ["komagata@gmail.com"]

  spec.summary = "Minimal feature flag gem"
  spec.description = "Simple boolean feature flags stored in database with web admin interface"
  spec.homepage = "https://github.com/komagata/switchlet"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.6"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/komagata/switchlet"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.1"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "sqlite3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
