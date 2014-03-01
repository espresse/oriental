require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "SKIP statement" do

  describe "SKIP" do
    describe "single skip statement" do
      before do
        @relation = Oriental::Relation.new("User").skip(10)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:skip].first, 10
      end

      it "should output query" do
        assert_equal "SELECT FROM User SKIP 10", @relation.to_sql
        end
    end

    describe "multiple group statements" do
      before do
        @relation = Oriental::Relation.new("User").skip(10).skip(1)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:skip], [10, 1]
      end

      it "should output query" do
        assert_equal "SELECT FROM User SKIP 10", @relation.to_sql
      end
    end
  end
end
