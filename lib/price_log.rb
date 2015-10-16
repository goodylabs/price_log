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

    def has_price_log(name, options = {})
      configuration = {
        name: name,
        dependent: :destroy
      }
      configuration.update(options) if options.is_a?(Hash)

      _field_name_ = configuration[:name]
      _relation_name_ = "all_#{_field_name_}_price_logs".to_sym
      has_many _relation_name_, -> (object){ where("priceable_field_name = ?", _field_name_.to_sym)},  {as: :priceable, dependent: :destroy, class_name: "PriceLogEntry", validate:false}

      _current_value_field_name_ = options[:current_value_field_name]

      class_eval %{
        def #{_field_name_}(date=nil)
          self.#{_relation_name_}.for_date(self.class.name, self.id, '#{_field_name_}', date).first
        end

        def #{_field_name_}=(amount)
          ple = PriceLogEntry.new(priceable: self, price: amount, start_date: DateTime.now, priceable_field_name: '#{_field_name_}')

          #{ !_current_value_field_name_.blank? ? "self.#{_current_value_field_name_} = amount if self.respond_to?('#{_current_value_field_name_}')" : ''}
          self.#{_relation_name_} << ple
        end

        def #{_field_name_}_dump
          self.#{_relation_name_}.each(&:pretty_print)
        end
      }

    end


  end

end

ActiveRecord::Base.send(:include, PriceLog)
