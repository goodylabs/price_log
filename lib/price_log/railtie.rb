module PriceLog

  class Railtie < Rails::Railtie
    initializer 'price_log.insert_into_active_record' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, PriceLog)
      end
    end
  end

end
