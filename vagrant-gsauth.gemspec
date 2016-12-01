$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'vagrant-gsauth/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-gsauth'
  spec.version       = VagrantPlugins::GSAuth::VERSION
  spec.authors       = ['Nikhil Benesch', 'Justin DiPierro']
  spec.email         = ['benesch@whoop.com', 'justin@conduce.com']
  spec.summary       = 'Private, versioned Vagrant boxes hosted on Google Cloud Storage.'
  spec.homepage      = 'https://github.com/conduceinc/vagrant-gsauth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(/spec/)
  spec.require_paths = ['lib']

  spec.add_dependency 'google-api-client', '~> 0.9'
  spec.add_dependency 'googleauth', '~> 0.5.1'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'http', '~> 1.0.2'
  spec.add_development_dependency 'rake', '~> 10.5.0'
  spec.add_development_dependency 'rubocop', '~> 0.36.0'
end
