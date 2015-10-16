require 'spec_helper'

describe PriceLog do

  before :all do
  end

  before :each do
    @p = Project.create
    @p2 = Project.create
    @p2.all_hourly_rate_price_logs << PriceLogEntry.create({price: Money.new(1000), start_date: 1.day.ago, priceable_field_name: 'hourly_rate'})
    @p2.all_hourly_rate_price_logs << PriceLogEntry.create({price: Money.new(2000), start_date: 2.day.ago, priceable_field_name: 'hourly_rate'})
    @p2.all_hourly_rate_price_logs << PriceLogEntry.create({price: Money.new(3000), start_date: 3.day.ago, priceable_field_name: 'hourly_rate'})
    @p2.all_hourly_rate_price_logs << PriceLogEntry.create({price: Money.new(4000), start_date: 4.day.ago, priceable_field_name: 'hourly_rate'})
    @p2.all_hourly_rate_price_logs << PriceLogEntry.create({price: Money.new(5000), start_date: 5.day.ago, priceable_field_name: 'hourly_rate'})
    @p2.all_hourly_rate_price_logs << PriceLogEntry.create({price: Money.new(6000), start_date: 6.day.ago, priceable_field_name: 'hourly_rate'})
    @p2.save
    @p2id = @p2.id

    # @p2.all_hourly_rate_price_logs.last.resolve_dates


  end

  after :each do
    Project.all.each(&:destroy)
  end


  it "creates price logs once assigned new" do
    @p.hourly_rate= Money.new(4535)
    expect(PriceLogEntry.where(priceable_id: @p.id).count).to be(1)
    expect(@p.all_hourly_rate_price_logs.length).to be(1)



    @p.hourly_rate= Money.new(4544)

    @p.save!
    expect(PriceLogEntry.where(priceable_id: @p.id).count).to be(2)
  end


  it "recalculates dates properly" do
    p2 = Project.find(@p2id)
    p2.hourly_rate_dump

    expect(p2.hourly_rate_log.start_date).to be < DateTime.now
    expect(p2.hourly_rate_log.end_date).to be_nil

    d1 = 4.days.ago
    expect(p2.hourly_rate_log(d1).start_date).to be <= d1
    expect(p2.hourly_rate_log(d1).end_date).not_to be_nil

    # no such value
    d1 = 14.days.ago
    expect(p2.hourly_rate(d1)).to be_nil

  end

  it "returns current value" do
    p2 = Project.find(@p2id)
    m = Money.new(4321)
    p2.hourly_rate = m
    # a = p2.all_hourly_rate_price_logs.for_date('Project', p2.id, 'hourly_rate', DateTime.now)
    # a = p2.all_hourly_rate_price_logs.where(priceable_id: p2.id, priceable_type: 'Project', priceable_field_name:'hourly_rate').where('start_date <= ? AND (end_date IS NULL OR end_date > ?)', DateTime.now, DateTime.now )
    expect(p2.hourly_rate).to eq(m)
  end


  it "can return value for particular date" do
    p2 = Project.find(@p2id)

    n0 = p2.hourly_rate
    n1 = p2.hourly_rate(1.day.ago)
    n2 = p2.hourly_rate(2.day.ago)
    n3 = p2.hourly_rate(3.day.ago)
    n4 = p2.hourly_rate(4.day.ago)
    n5 = p2.hourly_rate(5.day.ago)

    expect(n0.cents).to eq(1000)
    expect(n1.cents).to eq(1000)
    expect(n2.cents).to eq(2000)
    expect(n3.cents).to eq(3000)
    expect(n4.cents).to eq(4000)
    expect(n5.cents).to eq(5000)
  end


end
