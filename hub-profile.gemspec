# frozen_string_literal: true

require_relative "lib/hub/profile/version"

Gem::Specification.new do |spec|
  spec.name          = "hub-profile"
  spec.version       = Hub::Profile::VERSION
  spec.authors       = ["Alberto Colon Viera"]
  spec.email         = ["aacv@alberti.co"]

  spec.summary       = "Profile and authentication manager for the hub command line tool."
  spec.description   = "Profile and authentication manager for the hub command line tool."
  spec.homepage      = "https://github.com/albertico/hub-profile"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/albertico/hub-profile"
  # spec.metadata["changelog_uri"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-cli", "~> 0.6"
  spec.add_dependency "octokit", "~> 4.0"
end
