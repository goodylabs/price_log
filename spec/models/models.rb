class ProjectsMigration < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.timestamps
    end
  end
  def self.down
    drop_table :projects
  end
end

class Project < ActiveRecord::Base
  has_price_log :hourly_rate
end
