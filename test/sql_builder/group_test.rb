require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "GROUP statement" do

  describe "GROUP" do
    describe "single group statement" do
      before do
        @relation = Oriental::Relation.new("User").group(:first_name)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:group].first, :first_name
      end

      it "should output query" do
        assert_equal "SELECT FROM User GROUP BY first_name", @relation.to_sql
        end
    end

    describe "multiple group statements" do
      before do
        @relation = Oriental::Relation.new("User").group(:first_name).group(:last_name)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:group].first, :first_name
      end

      it "should output query" do
        assert_equal "SELECT FROM User GROUP BY first_name", @relation.to_sql
      end
    end
  end
end
