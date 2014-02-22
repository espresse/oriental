require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "RecordId" do

  it "should parse orientdb's record id" do
    record_id = Oriental::RecordId.new("#5:0")
    assert_equal 5, record_id.cluster
    assert_equal 0, record_id.position
  end

  it "should parse orientdb's record id without leading #" do
    record_id = Oriental::RecordId.new("5:0")
    assert_equal 5, record_id.cluster
    assert_equal 0, record_id.position
  end

  it "should create new RecordId from empty string" do
    record_id = Oriental::RecordId.new("")
    assert_equal nil, record_id.cluster
    assert_equal nil, record_id.position
  end

  it "should create new RecordId passing nil as parameter" do
    record_id = Oriental::RecordId.new()
    assert_equal nil, record_id.cluster
    assert_equal nil, record_id.position
  end

  it "should skip parsing when initializing with RecordId" do
    record_id = Oriental::RecordId.new('#5:1')
    other_record_id = Oriental::RecordId.new(record_id)

    assert_equal 5, other_record_id.cluster
    assert_equal 1, other_record_id.position
  end

  it "should parse temporary rid" do
    record_id = Oriental::RecordId.new('#-2:1')
    assert_equal -2, record_id.cluster
    assert_equal 1, record_id.position
  end

  it "should tell if record is temporary" do
    record_id = Oriental::RecordId.new('#-2:1')
    assert record_id.temporary?
  end

  it "should return rid string" do
    record_id = Oriental::RecordId.new('#-2:1')
    assert_equal "#-2:1", record_id.to_s
  end
end
