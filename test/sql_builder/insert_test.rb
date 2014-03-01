require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "INSERT statement" do

  describe "INSERT" do

    it "should work with simple functions" do
      relation = Oriental::Relation.new("User").insert
      assert_equal "INSERT INTO User", relation.to_sql
    end

    it "should raise an error when adding wrong data" do
      assert_raises RuntimeError do
        relation = Oriental::Relation.new("OUser").insert.set(name: 'root').first
      end
    end

    it "should add data" do
      relation = Oriental::Relation.new("OUser").insert.set(name: (rand(36**8).to_s(36)), password: 'secret', status: "ACTIVE").to_a
      assert relation.is_a? Array
      assert_equal 1, relation.length
      assert_equal "ACTIVE", relation[0].parameters[:status]
    end

    describe "SET" do
      it "should add data" do
        relation = Oriental::Relation.new("User").insert.set(name: "admin")
        assert_equal "INSERT INTO User SET name = \"admin\"", relation.to_sql
      end

      it "should be able to set more values" do
        relation = Oriental::Relation.new("User").insert.set(name: "admin", password: "secret")
        assert_equal "INSERT INTO User SET name = \"admin\", password = \"secret\"", relation.to_sql
      end

      it "should be able to add number data" do
        relation = Oriental::Relation.new("User").insert.set(name: "admin", age: 42, points: 12.45)
        assert_equal "INSERT INTO User SET name = \"admin\", age = 42, points = 12.45", relation.to_sql
      end

      it "should be able to add array data" do
        relation = Oriental::Relation.new("User").insert.set(name: "admin", ary: [12, "name", {attributes: {status: "active", counter: 1, created_at: DateTime.parse("2014-02-28T11:29:23+01:00")}}])
        assert_equal "INSERT INTO User SET name = \"admin\", ary = [12, \"name\", {'attributes':{'status':\"active\", 'counter':1, 'created_at':\"2014-02-28T11:29:23+01:00\"}}]", relation.to_sql
      end

      it "should be able to add set data" do
        relation = Oriental::Relation.new("User").insert.set(name: "admin", ary: Set.new([12, "name", {attributes: {status: "active", counter: 1, created_at: DateTime.parse("2014-02-28T11:29:23+01:00")}}]))
        assert_equal "INSERT INTO User SET name = \"admin\", ary = Set(12, \"name\", {'attributes':{'status':\"active\", 'counter':1, 'created_at':\"2014-02-28T11:29:23+01:00\"}})", relation.to_sql
      end

      it "should be able to embedd a document" do
        relation = Oriental::Relation.new("User").insert.set(name: "admin", embedded: { :@type => "d", attributes: {status: "active", counter: 1, created_at: DateTime.parse("2014-02-28T11:29:23+01:00")}})
        assert_equal "INSERT INTO User SET name = \"admin\", embedded = {'@type':\"d\", 'attributes':{'status':\"active\", 'counter':1, 'created_at':\"2014-02-28T11:29:23+01:00\"}}", relation.to_sql
      end
    end
  end
end
