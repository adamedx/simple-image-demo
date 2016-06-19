# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)


# $:.unshift(File.dirname(__FILE__) + "/lib")
require "simple-image-demo/version"

Gem::Specification.new do |s|
  s.name = "simple-image-demo"
  s.version = SimpleImageDemo::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "A demonstration of a simple json-based file format for visual images"
  s.description = s.summary
  s.license = "Apache-2.0"
  s.author = "Adam Edwards"
  s.homepage = "https://github.com/adamedx"

  s.required_ruby_version = ">= 2.1.0"

  s.add_dependency "json"
  s.add_dependency "bson"

  s.add_development_dependency "bundler", "~> 1.11"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency 'pry'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
#  s.files = %w{Gemfile Rakefile LICENSE README.md} + Dir.glob("{html,lib,spec}/**/*", File::FNM_DOTMATCH).reject { |f| File.directory?(f) } + Dir.glob("*.gemspec")
end
