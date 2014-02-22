require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Where statement" do

  describe "Where" do
    before do
      @relation = Oriental::Relation.new("User").where(name: "abc")
    end

    it "should add condition" do
      assert_equal @relation.criteria[:conditions].first, "(name = :name)"
    end

    it "should have params" do
      assert_equal @relation.criteria[:params], {name: "abc"}
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (name = 'abc')", @relation.to_sql
    end
  end

  describe "Where - and condition" do
    before do
      @relation = Oriental::Relation.new("User").where(name: "abc", other: "def")
    end

    it "should add condition" do
      assert_equal @relation.criteria[:conditions].first, "(name = :name AND other = :other)"
    end

    it "should have params" do
      assert_equal @relation.criteria[:params], {name: "abc", other: "def"}
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (name = 'abc' AND other = 'def')", @relation.to_sql
    end
  end

  describe "Where - or condition" do
    before do
      @relation = Oriental::Relation.new("User").where({name: "abc"}, {other: "def"})
    end

    it "should add condition" do
      assert_equal @relation.criteria[:conditions].first, "(name = :name) OR (other = :other)"
    end

    it "should have params" do
      assert_equal @relation.criteria[:params], {name: "abc", other: "def"}
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (name = 'abc') OR (other = 'def')", @relation.to_sql
    end
  end

  describe "Where - and && or condition" do
    before do
      @relation = Oriental::Relation.new("User").where({name: "abc", other: "def"}, {foo: "oof", bar: "rab"}).where(baz: "zab")
    end

    it "should have params" do
      assert_equal @relation.criteria[:params], {name: "abc", other: "def", foo: "oof", bar: "rab", baz: "zab"}
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (name = 'abc' AND other = 'def') OR (foo = 'oof' AND bar = 'rab') AND (baz = 'zab')", @relation.to_sql
    end
  end

  describe "Operators" do
    describe '$like' do
      before do
        @relation = Oriental::Relation.new("User").where(:$like => {name: "%ad%"})
      end

      it "should add condition" do
        assert_equal "(name LIKE :name)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal '%ad%', @relation.criteria[:params][:name]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (name LIKE '%ad%')", @relation.to_sql
      end
    end

    describe '$is' do
      before do
        @relation = Oriental::Relation.new("User").where(:$is => {name: nil})
      end

      it "should add condition" do
        assert_equal "(name IS null)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal nil, @relation.criteria[:params][:name]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (name IS null)", @relation.to_sql
      end
    end

    describe "=" do
      before do
        @relation = Oriental::Relation.new("User").where("=" => {name: "admin"})
      end

      it "should add condition" do
        assert_equal "(name = :name)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "admin", @relation.criteria[:params][:name]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (name = 'admin')", @relation.to_sql
      end
    end

    describe ">" do
      before do
        @relation = Oriental::Relation.new("User").where(">" => {id: 4})
      end

      it "should add condition" do
        assert_equal "(id > :id)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal 4, @relation.criteria[:params][:id]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id > 4)", @relation.to_sql
      end
    end

    describe "<" do
      before do
        @relation = Oriental::Relation.new("User").where("<" => {id: 4})
      end

      it "should add condition" do
        assert_equal "(id < :id)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal 4, @relation.criteria[:params][:id]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id < 4)", @relation.to_sql
      end
    end

    describe ">=" do
      before do
        @relation = Oriental::Relation.new("User").where(">=" => {id: 4})
      end

      it "should add condition" do
        assert_equal "(id >= :id)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal 4, @relation.criteria[:params][:id]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id >= 4)", @relation.to_sql
      end
    end

    describe "<=" do
      before do
        @relation = Oriental::Relation.new("User").where("<=" => {id: 4})
      end

      it "should add condition" do
        assert_equal "(id <= :id)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal 4, @relation.criteria[:params][:id]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id <= 4)", @relation.to_sql
      end
    end

    describe "<>" do
      before do
        @relation = Oriental::Relation.new("User").where("<>" => {id: 4})
      end

      it "should add condition" do
        assert_equal "(id <> :id)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal 4, @relation.criteria[:params][:id]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id <> 4)", @relation.to_sql
      end
    end

    describe "$between" do
      before do
        @relation = Oriental::Relation.new("User").where(:$between => {id: 4..8})
      end

      it "should add condition" do
        assert_match /(id BETWEEN :\w+ AND :\w+)/, @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal [4, 8], @relation.criteria[:params].values
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id BETWEEN 4 AND 8)", @relation.to_sql
      end
    end

    describe "$in" do
      before do
        @relation = Oriental::Relation.new("User").where(:$in => {id: [4,8]})
      end

      it "should add condition" do
        assert_equal "(id IN :id)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal [4, 8], @relation.criteria[:params][:id]
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (id IN [4, 8])", @relation.to_sql
      end
    end

    describe "$instanceof" do
      before do
        @relation = Oriental::Relation.new("User").where(:$instanceof => {:@this => "User"})
      end

      it "should add condition" do
        assert_match /(@this INSTANCEOF :(\w+))/, @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "User", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (@this INSTANCEOF 'User')", @relation.to_sql
      end
    end

    describe "$contains" do
      before do
        @relation = Oriental::Relation.new("User").where(:$contains => {children: {name: 'admin'}})
      end

      it "should add condition" do
        assert_match /children CONTAINS \(name = :\w+\)/, @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "admin", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (children CONTAINS (name = 'admin'))", @relation.to_sql
      end
    end

    describe "$containsall" do
      before do
        @relation = Oriental::Relation.new("User").where(:$containsall => {children: {name: 'admin'}})
      end

      it "should add condition" do
        assert_match /children CONTAINSALL \(name = :\w+\)/, @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "admin", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (children CONTAINSALL (name = 'admin'))", @relation.to_sql
      end
    end

    describe "$containskey" do
      before do
        @relation = Oriental::Relation.new("User").where(:$containskey => {collection: 'key_name'})
      end

      it "should add condition" do
        assert_equal "(collection CONTAINSKEY :collection)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "key_name", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (collection CONTAINSKEY 'key_name')", @relation.to_sql
      end
    end

    describe "$containsvalue" do
      before do
        @relation = Oriental::Relation.new("User").where(:$containskey => {collection: '12:3'})
      end

      it "should add condition" do
        assert_equal "(collection CONTAINSKEY :collection)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "12:3", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (collection CONTAINSKEY '12:3')", @relation.to_sql
      end
    end

    describe "$containstext" do
      before do
        @relation = Oriental::Relation.new("User").where(:$containstext => {description: 'admin'})
      end

      it "should add condition" do
        assert_equal "(description CONTAINSTEXT :description)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "admin", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (description CONTAINSTEXT 'admin')", @relation.to_sql
      end
    end

    describe "$matches" do
      before do
        @relation = Oriental::Relation.new("User").where(:$matches => {name: /ad%/})
      end

      it "should add condition" do
        assert_equal "(name MATCHES :name)", @relation.criteria[:conditions].first
      end

      it "should have params" do
        assert_equal "ad%", @relation.criteria[:params].values.first
      end

      it "should output query" do
        assert_equal "SELECT FROM User WHERE (name MATCHES 'ad%')", @relation.to_sql
      end
    end
  end

  describe "Range" do
    before do
      @relation = Oriental::Relation.new("User").where(id: 4..8)
    end

    it "should add condition" do
      assert_match /(id BETWEEN :\w+ AND :\w+)/, @relation.criteria[:conditions].first
    end

    it "should have params" do
      assert_equal [4, 8], @relation.criteria[:params].values
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (id BETWEEN 4 AND 8)", @relation.to_sql
    end
  end

  describe "Array" do
    before do
      @relation = Oriental::Relation.new("User").where(id: [4, 8])
    end

    it "should add condition" do
      assert_equal "(id IN :id)", @relation.criteria[:conditions].first
    end

    it "should have params" do
      assert_equal [4, 8], @relation.criteria[:params][:id]
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (id IN [4, 8])", @relation.to_sql
    end
  end

  describe "Regexp" do
    before do
      @relation = Oriental::Relation.new("User").where(name: /ad%/)
    end

    it "should add condition" do
      assert_equal "(name MATCHES :name)", @relation.criteria[:conditions].first
    end

    it "should have params" do
      assert_equal "ad%", @relation.criteria[:params].values.first
    end

    it "should output query" do
      assert_equal "SELECT FROM User WHERE (name MATCHES 'ad%')", @relation.to_sql
    end
  end
end
