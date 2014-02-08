# frozen_string_literal: true

require_relative 'lib/philiprehberger/base_convert/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-base_convert'
  spec.version       = Philiprehberger::BaseConvert::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Multi-format base encoding with Base32, Base58, Base62, and Base85 support'
  spec.description   = 'Encode and decode data in Base32 (Crockford), Base58 (Bitcoin), Base62, and ' \
                        'Base85 (ASCII85) formats. Also supports arbitrary base encoding for integers ' \
                        'from base 2 to 62.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-base-convert'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
