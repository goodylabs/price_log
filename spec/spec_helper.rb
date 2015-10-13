require 'rubygems'
require 'rspec'
require 'active_record'
require 'active_record/version'
require 'active_support'
require 'active_support/core_ext'
require 'mocha/api'
# require 'bourne'
# require 'ostruct'
require 'pathname'
# require 'activerecord-import'
require 'factory_girl'
require 'price_log'
require 'money'
require 'money-rails'
require 'rails'
# require 'money-rails/active_record/migration_extensions/table'
# require "money-rails/active_record/migration_extensions/table_pg_rails4"
# require "money-rails/active_record/migration_extensions/schema_statements"
# require 'money-rails/active_record/monetizable'
# require 'money-rails/active_model/validator'
# require 'money-rails/active_record/monetizable'

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

puts "Testing against version #{ActiveRecord::VERSION::STRING}"

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'price_log')
# $LOAD_PATH << File.join(ROOT, 'lib', 'price_log')
# $LOAD_PATH << File.join(ROOT, 'spec', 'models')




require File.join(ROOT, 'lib', 'price_log.rb')
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
ActiveRecord::Base.logger = Logger.new(STDOUT)

# database
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
@connection = ActiveRecord::Base.establish_connection(config['test'])

unless ActiveRecord::VERSION::STRING < "4.2"
  ActiveRecord::Base.raise_in_transactional_callbacks = true
end

Dir["spec/models/**/*.rb"].each { |f| require File.expand_path(f) }

MoneyRails::Hooks.init

require File.expand_path(File.dirname(__FILE__) + '/../lib/generators/price_log/templates/create_price_log_entries.rb')
load File.expand_path(File.dirname(__FILE__) + '/../lib/generators/price_log/templates/price_log_entry.rb')

RSpec.configure do |config|
  # config.include FactoryGirl::Syntax::Methods
  config.mock_framework = :mocha
  # config.include DeclarationMatchers

  config.before do
    CreatePriceLogEntries.up
    ProjectsMigration.up
  end

  config.after do
    CreatePriceLogEntries.down
    ProjectsMigration.down
    # Timecop.return
    FactoryGirl.reload
  end
end
