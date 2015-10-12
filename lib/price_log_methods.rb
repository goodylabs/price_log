module PriceLog

  module PriceLog
    def self.included(price_log_model)
      price_log_model.extend Finders
      price_log_model.scope :in_order, -> { price_log_model.order('created_at ASC') }
      price_log_model.scope :recent, -> { price_log_model.reorder('created_at DESC') }
    end

    # def is_comment_type?(type)
    #   type.to_s == role.singularize.to_s
    # end

    module Finders

      def find_price_log_for_priceable(priceable_type, priceable_id, priceable_field_name)
        PriceLog.where( priceable_type: priceable_type, priceable_id: priceable_id, priceable_field_name: priceable_field_name )
      end

      def find_price_log_for_priceable_for_date(priceable_type, priceable_id, priceable_field_name, date)
        PriceLog.find_price_log_for_priceable(priceable_type, priceable_id, priceable_field_name).where("start_date <= ? and ( end_date IS NULL or end_date <= ?)", date, date).first
      end

    end
  end
end
