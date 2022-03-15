require_relative "lib/dato/version"

Gem::Specification.new do |spec|
  spec.name = "dato-rails"
  spec.version = Dato::VERSION
  spec.authors = ["Alessandro Rodi"]
  spec.email = ["alessandro.rodi@renuo.ch"]
  spec.homepage = "https://github.com/renuo/dato-rails"
  spec.summary = "Use Dato CMS in your Rails application."
  spec.description = "This gem allows you to fetch data using Dato GraphQL APIs and render the content in your Rails app."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/renuo/dato-rails"
  spec.metadata["changelog_uri"] = "https://github.com/renuo/dato-rails/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency "rspec-rails", ">= 3.0"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "capybara"

  spec.add_dependency "view_component", ">= 2.0"
  spec.add_dependency "rails", ">= 4"
  spec.add_dependency "turbo-rails", ">= 1"
  spec.add_dependency "gqli", ">= 1"
  spec.add_dependency "zeitwerk", ">= 1"
end
