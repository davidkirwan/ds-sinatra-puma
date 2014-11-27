$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rake'

Gem::Specification.new do |s|
  s.name = 'ds-demo-gem'
  s.version = '0.1.0'
  s.date = '2014-11-26'
  s.summary = 'Distributed Systems Demo Gem'
  s.description = <<-DESCRIPTION
Distributed Systems Demo Gem
DESCRIPTION

  s.authors = ['David Kirwan']
  s.email = ['dkirwan@tssg.org']
  s.require_paths = ["lib"]
  s.files = FileList['lib/**/*.rb',
                     '[A-Z]*',
                     'spec/**/*'].to_a
  s.homepage = 'https://github.com/davidkirwan/ds-sinatra-puma'
  s.post_install_message = <<-INSTALL
Git Repository: https://github.com/davidkirwan/ds-sinatra-puma
INSTALL

  s.license = 'GPL 3.0'

  s.add_runtime_dependency 'bunny', '~> 1.1.0'
end
