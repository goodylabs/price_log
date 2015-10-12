class PriceLogEntry < ActiveRecord::Base
  monetize :price_cents,  with_model_currency: :price_currency
  belongs_to :priceable, :polymorphic => true

  after_create :resolve_dates

  validates :priceable_id, :priceable_type, :priceable_field_name, presence: true

  scope :all_for_priceable, ->(priceable_type, priceable_id, priceable_field_name){
    where(priceable_id: priceable_id, priceable_type: priceable_type, priceable_field_name:priceable_field_name)
  }
  scope :for_date, ->(priceable_type, priceable_id, priceable_field_name,  date) {
    unless date.nil?
      all_for_priceable(priceable_type, priceable_id, priceable_field_name).where('start_date <= ? AND (end_date IS NULL OR end_date > ?)', date, date )
    else
      all_for_priceable(priceable_type, priceable_id, priceable_field_name).where('start_date <= ? AND end_date IS NULL', DateTime.now)
    end
  }


  def resolve_dates
    _all_ = PriceLogEntry.all_for_priceable(self.priceable_type, self.priceable_id, self.priceable_field_name)
    prev_start_date = nil
    self.logger.info "Recalculates #{self.priceable_type}, #{self.priceable_id}, #{self.priceable_field_name}"
    _all_.order("start_date DESC").each do |ple|
      unless prev_start_date.nil?
        ple.end_date = prev_start_date
        ple.save!
      end
      prev_start_date = ple.start_date
    end
    true
  end

  def pretty_print
    puts "#{self.priceable_type}, #{self.priceable_id}, #{self.priceable_field_name}, start_date: #{self.start_date}, end_date: #{self.end_date}"
  end

end
