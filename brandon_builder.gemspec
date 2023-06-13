# frozen_string_literal: true

require_relative "lib/brandon_builder/version"

Gem::Specification.new do |spec|
  spec.name = "brandon_builder"
  spec.version = BrandonBuilder::VERSION
  spec.authors = ["Pedro Perafan"]
  spec.email = ["pedro.perafan.carrasco@gmail.com"]

  spec.summary = "Flexible object construction and DSL using Builder pattern."
  spec.description = "BrandonBuilder is a Ruby gem that provides a flexible object construction approach using the Builder pattern, combined with a powerful DSL (Domain Specific Language) for simplifying complex workflows."
  spec.homepage = "https://github.com/Perafan18/brandon_builder"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Perafan18/brandon_builder"
  spec.metadata["changelog_uri"] = "https://github.com/Perafan18/brandon_builder/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
