# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sneaker/version"

Gem::Specification.new do |spec|
  spec.name          = "sneaker"
  spec.version       = Sneaker::VERSION
  spec.authors       = ["Ideas4allInnovation"]
  spec.email         = ["admin@ideas4allinnovation.com"]

  spec.summary       = %q{Sneak rails commands in multiple capistrano stages}
  spec.description   = %q{Sneaker lets you launch a rails command in multiple capistrano stages simultaneously}
  spec.homepage      = "https://github.com/i4a/sneaker"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "gem-release"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "tty-table", "~> 0.10.0"
  spec.add_dependency "tty-cursor", "~> 0.5.0"
  spec.add_dependency "pastel", "~> 0.7.2"
end
