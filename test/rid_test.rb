require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Rid" do
  before do
    class User
      include Virtus.model

      attribute :rid, Oriental::Rid
    end

    @user = User.new(rid: "#5:1")
    @another = User.new(rid: Oriental::RecordId.new('#5:0'))
  end

  it "should parse orientdb's record id" do
    assert_equal @user.rid, Oriental::RecordId.new("#5:1")
  end

  it "should parse orientdb's record id" do
    assert_equal @another.rid, Oriental::RecordId.new("#5:0")
  end
end
