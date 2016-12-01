source 'https://rubygems.org'

VAGRANT_REF = ENV['VAGRANT_VERSION'] || 'master'

group :development do
  gem 'vagrant', git: 'git://github.com/mitchellh/vagrant.git', ref: VAGRANT_REF
end

group :plugins do
  gemspec
  gem 'google-api-client', require: 'google/apis/storage_v1'
  gem 'vagrant-aws', git: 'git://github.com/mitchellh/vagrant-aws.git', ref: 'master'
end
