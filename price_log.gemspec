# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'price_log/version'

Gem::Specification.new do |spec|
  spec.name          = "price_log"
  spec.version       = PriceLog::VERSION
  spec.authors       = ["Andrzej Liśkiewicz"]
  spec.email         = ["andrzej.liskiewicz@goodylabs.com"]
  spec.summary       = %q{Price history.}
  spec.description   = %q{Price history with easy.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # spec.files         = ['lib/price_log.rb'] #`git ls-files -z`.split("\x0")
  spec.files         = ['Gemfile','LICENSE.txt','README.md','Rakefile','lib/generators/price_log/templates/price_log_entry.rb','lib/generators/price_log/templates/create_price_log_entries.rb','lib/price_log.rb','lib/price_log/railtie.rb','lib/price_log/version.rb','lib/price_log_methods.rb']
  spec.test_files    = `git ls-files -- {spec}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]



  spec.add_dependency "activerecord", ">= 3.0.0"
  spec.add_dependency('activemodel', '>= 3.2.0')
  spec.add_dependency('activesupport', '>= 3.2.0')
  spec.add_dependency('money', '~> 6.5.0')
  spec.add_dependency('money-rails', '>= 1.4.1')



  # runtime
  # spec.add_runtime_dependency 'activerecord'#, '~> 3.0', '>= 3.0.0'

  # development

  spec.add_development_dependency "factory_girl"#, "~> 1.7"
  spec.add_development_dependency "mocha"#, "~> 1.7"
  spec.add_development_dependency "bundler"#, "~> 1.7"
  spec.add_development_dependency "rake"#, "~> 10.0"
  spec.add_development_dependency 'sqlite3'#, '~> 0'
  spec.add_development_dependency 'minitest'#, '~> 4.7', '>= 4.7.5'
  spec.add_development_dependency "rspec"

  # spec.add_development_dependency 'rdoc', '~> 0'

end
