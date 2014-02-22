require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Base Attributes" do

  before do
    class Timestamp
      include Virtus::Model
      include Oriental::Attributes::Timestamp
    end

    @now = DateTime.now()
    @timestamp = Timestamp.new(created_at: @now, updated_at: @now)
  end

  it "should parse created_at" do
    assert Timestamp.method_defined?(:created_at)
    assert_equal @now, @timestamp.created_at
  end

  it "should parse updated_at" do
    assert Timestamp.method_defined?(:updated_at)
    assert_equal @now, @timestamp.updated_at
  end
end
