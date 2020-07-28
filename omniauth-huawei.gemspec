# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-huawei/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-huawei'
  spec.authors       = ['liangyinghao']
  spec.email         = ['lyh1208401418@gmail.com']
  spec.version       = Omniauth::Huawei::VERSION
  spec.description   = %q{Oauth2 Gem for huawei.com}
  spec.summary       = %q{Oauth2 Gem for huawei.com}
  spec.homepage      = 'https://gitee.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
