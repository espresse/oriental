require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Base Fields" do

  before do
    class Base
      include Oriental::Document
    end

    @user = Base.new(rid: "#5:0", _klass: "User", _type: "d", missing: "missing")
  end

  it "should parse klass" do
    assert Base.method_defined?(:_klass)
    assert_equal @user._klass, "User"
  end

  it "should parse type" do
    assert Base.method_defined?(:_type)
    assert_equal @user._type, "d"
  end

  it "should parse rid" do
    assert Base.method_defined?(:rid)
    assert_equal Oriental::RecordId.new('#5:0'), @user.rid
  end

  it "should not add missing" do
    assert Base.method_defined?(:missing)
  end
end
