require "price_log/version"


module PriceLog

  # Your code goes here...
  if defined? Rails::Railtie
    require 'price_log/railtie'
  elsif defined? Rails::Initializer
    raise "price_log is not compatible with Rails 2.3 or older"
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods


    def has_price_log(options = {})
      configuration = {
        name:         nil,
        dependent:     :destroy
      }

      configuration.update(options) if options.is_a?(Hash)

    end


  end

end
