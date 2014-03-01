require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "SELECT statement" do

  describe "SELECT" do
    describe "use object's fields names" do
      before do
        @relation = Oriental::Relation.new("User").select('name')
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], ['name']
      end

      it "should output query" do
        assert_equal "SELECT name FROM User", @relation.to_sql
      end
    end

    describe "Include fields" do
      before do
        @relation = Oriental::Relation.new("User").select(roles: {include: [:name, :@class, :rules]})
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [roles: {include: [:name, :@class, :rules]}]
      end

      it "should output query" do
        assert_equal "SELECT roles.include('name', '@class', 'rules') FROM User", @relation.to_sql
      end
    end

    describe "Exclude fields" do
      before do
        @relation = Oriental::Relation.new("User").select(roles: {exclude: [:name]})
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [roles: {exclude: [:name]}]
      end

      it "should output query" do
        assert_equal "SELECT roles.exclude('name') FROM User", @relation.to_sql
      end
    end

    describe "Out fields" do
      before do
        @relation = Oriental::Relation.new("User").select(out: :roles)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [out: :roles]
      end

      it "should output query" do
        assert_equal "SELECT out(roles) FROM User", @relation.to_sql
      end
    end

    describe "In fields" do
      before do
        @relation = Oriental::Relation.new("User").select(in: :roles)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [in: :roles]
      end

      it "should output query" do
        assert_equal "SELECT in(roles) FROM User", @relation.to_sql
      end
    end

    describe "Out fields with include fields" do
      before do
        @relation = Oriental::Relation.new("User").select(out: {roles: {include: [:name]}})
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [out: {roles: {include: [:name]}}]
      end

      it "should output query" do
        assert_equal "SELECT out(roles).include('name') FROM User", @relation.to_sql
      end
    end

    describe "Out fields with include and exclude fields" do
      before do
        @relation = Oriental::Relation.new("User").select(out: {roles: {include: [:name], exclude: [:rid]}})
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [out: {roles: {include: [:name], exclude: [:rid]}}]
      end

      it "should output query" do
        assert_equal "SELECT out(roles).include('name').exclude('rid') FROM User", @relation.to_sql
      end
    end

    describe "Expand field" do
      before do
        @relation = Oriental::Relation.new("User").select(expand: :roles)
      end

      it "should add condition" do
        assert_equal @relation.criteria[:fields], [expand: :roles]
      end

      it "should output query" do
        assert_equal "SELECT expand(roles) FROM User", @relation.to_sql
      end
    end

    describe "Functions" do

      it "should work with simple functions" do
        relation = Oriental::Relation.new("User").select(min: '@version')
        assert_equal "SELECT min(@version) FROM User", relation.to_sql
      end

      it "should work strings" do
        relation = Oriental::Relation.new("User").select("min(@version) as Version")
        assert_equal "SELECT min(@version) as Version FROM User", relation.to_sql
      end

      it "should be able to add fields" do
        relation = Oriental::Relation.new("User").select(first: {roles: [:name]})
        assert_equal "SELECT first(roles)['name'] FROM User", relation.to_sql
      end
    end
  end

end
