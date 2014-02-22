require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "LET statement" do

  describe "LET" do
    before do
      @relation = Oriental::Relation.new("User").let(:$temp => "address.city")
    end

    it "should add condition" do
      assert_equal @relation.criteria[:let].first, {:$temp => 'address.city'}
    end

    it "should output query" do
      assert_equal "SELECT FROM User LET ($temp = address.city)", @relation.to_sql
    end
  end
end
