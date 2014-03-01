require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "LIMIT statement" do

  describe "LIMIT" do
    describe "single limit statement" do
      before do
        @relation = Oriental::Relation.new("User").limit(10)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:limit].first, 10
      end

      it "should output query" do
        assert_equal "SELECT FROM User LIMIT 10", @relation.to_sql
        end
    end

    describe "multiple group statements" do
      before do
        @relation = Oriental::Relation.new("User").limit(10).limit(1)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:limit], [10, 1]
      end

      it "should output query" do
        assert_equal "SELECT FROM User LIMIT 10", @relation.to_sql
      end
    end
  end
end
