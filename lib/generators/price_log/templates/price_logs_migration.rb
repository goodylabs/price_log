class PriceLogsMigration < ActiveRecord::Migration
  def self.up
    create_table :price_log_entries do |t|
      t.monetize :price
      t.datetime :start_date
      t.datetime :end_date

      t.references :priceable, :polymorphic => true
      t.string :priceable_field_name

      t.timestamps
    end

    add_index :price_log_entries, :start_date
    add_index :price_log_entries, :end_date
    add_index :price_log_entries, :priceable_field_name
  end

  def self.down
    drop_table :price_log_entries
  end
end
