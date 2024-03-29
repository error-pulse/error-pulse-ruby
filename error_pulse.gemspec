# frozen_string_literal: true

require_relative 'lib/error_pulse/version'

Gem::Specification.new do |spec|
  spec.name = 'error_pulse'
  spec.version = ErrorPulse::VERSION
  spec.authors = ['Gerrit Schimpf']
  spec.email = ['info@error-pulse.com']

  spec.summary = 'Gem to report errors to error-pulse'
  spec.description = 'Gem to report errors to error-pulse'
  spec.homepage = 'https://error-pulse.com'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'httparty', '~> 0.21'
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
