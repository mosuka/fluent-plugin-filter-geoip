# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-filter-geoip"
  spec.version       = "0.5.0"
  spec.authors       = ["Minoru Osuka"]
  spec.email         = ["minoru.osuka@gmail.com"]

  spec.summary       = "Fluent filter plugin for adding GeoIP data to record."
  spec.description   = "Fluent filter plugin for adding GeoIP data to record. Supports the new Maxmind v2 database formats."
  spec.homepage      = "https://github.com/mosuka/fluent-plugin-filter-geoip"

  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'fluentd', '~> 0.14.6'
  spec.add_runtime_dependency 'maxminddb', '~> 0.1.11'

  spec.add_development_dependency 'bundler', '~> 1.13.6'
  spec.add_development_dependency 'rake', '~> 11.1.2'
  spec.add_development_dependency 'test-unit', '~> 3.1.5'
  spec.add_development_dependency 'minitest', '~> 5.8.3'
end
