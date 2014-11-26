# -*- encoding: utf-8 -*-
# stub: redstorm 0.7.0.beta1 ruby lib

Gem::Specification.new do |s|
  s.name = "redstorm"
  s.version = "0.7.0.beta1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Colin Surprenant"]
  s.date = "2014-11-23"
  s.description = "JRuby integration & DSL for the Storm distributed realtime computation system"
  s.email = ["colin.surprenant@gmail.com"]
  s.executables = ["redstorm"]
  s.files = ["bin/redstorm"]
  s.homepage = "https://github.com/colinsurprenant/redstorm"
  s.licenses = ["Apache 2.0"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "redstorm"
  s.rubygems_version = "2.1.9"
  s.summary = "JRuby on Storm"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.13"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.13"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.13"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
