require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "ORDER statement" do

  describe "ORDER" do
    describe "multiple order's params" do
      before do
        @relation = Oriental::Relation.new("User").order(first_name: :asc).order(last_name: :desc)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:order].first, {first_name: :asc}
      end

      it "should output query" do
        assert_equal "SELECT FROM User ORDER BY first_name asc, last_name desc", @relation.to_sql
        end
    end

    describe "single order params" do
      before do
        @relation = Oriental::Relation.new("User").order(first_name: :asc, last_name: :desc)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:order].first, {first_name: :asc}
      end

      it "should output query" do
        assert_equal "SELECT FROM User ORDER BY first_name asc, last_name desc", @relation.to_sql
      end
    end
  end
end
