require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Base Attributes" do

  before do
    class Base
      include Virtus::Model
      include Oriental::Attributes::Base
    end

    @user = Base.new(rid: "#5:0", klass: "User", type: "d", missing: "missing")
  end

  it "should parse klass" do
    assert Base.method_defined?(:klass)
    assert_equal @user.klass, "User"
  end

  it "should parse type" do
    assert Base.method_defined?(:type)
    assert_equal @user.type, "d"
  end

  it "should parse rid" do
    assert Base.method_defined?(:rid)
    assert_equal Oriental::RecordId.new('#5:0'), @user.rid
  end

  it "should not add missing" do
    assert !Base.method_defined?(:missing)
  end
end
