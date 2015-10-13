require 'rails/generators/migration'

module PriceLog
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    def self.source_root
      @_price_log_source_root ||= File.expand_path("../templates", __FILE__)
    end

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_model_file
      template "price_log_entry.rb", "app/models/price_log_entry.rb"
      migration_template "create_price_log_entries.rb", "db/migrate/create_price_log_entries.rb"
    end
  end
end
