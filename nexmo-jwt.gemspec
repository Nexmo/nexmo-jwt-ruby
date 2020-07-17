require File.expand_path('lib/nexmo-jwt/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'nexmo-jwt'
  s.version = Nexmo::JWT::VERSION
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Nexmo']
  s.email = ['devrel@nexmo.com']
  s.homepage = 'https://github.com/Nexmo/nexmo-jwt-ruby'
  s.description = 'Nexmo JWT Generator for Ruby'
  s.summary = 'This is the Ruby client library to generate Nexmo JSON Web Tokens (JWTs).'
  s.files = Dir.glob('lib/**/*.rb') + %w(LICENSE.txt README.md nexmo-jwt.gemspec)
  s.required_ruby_version = '>= 2.5.0'
  s.add_dependency('jwt', '~> 2')
  s.require_path = 'lib'
  s.metadata = {
    'homepage' => 'https://github.com/Nexmo/nexmo-jwt-ruby',
    'source_code_uri' => 'https://github.com/Nexmo/nexmo-jwt-ruby',
    'bug_tracker_uri' => 'https://github.com/Nexmo/nexmo-jwt-ruby/issues',
    'changelog_uri' => 'https://github.com/Nexmo/nexmo-jwt-ruby/blob/master/CHANGES.md',
    'documentation_uri' => 'https://rubydoc.info/github/Nexmo/nexmo-jwt-ruby'
  }
end
