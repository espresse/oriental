require File.expand_path '../../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "FIND statement" do
  describe "FIND" do
    before do
      @reader = Oriental::Relation.new(OUser).find("#5:1")
      @both = Oriental::Relation.new(OUser).find(['#5:0', '#5:1'])
    end

    it "should return object" do
      assert_equal Oriental::RecordId.new('#5:1'), @reader.parameters[:@rid]
    end

    it "should return array" do
      assert_equal 2, @both.length
    end
  end

  describe "FIND_BY" do
    before do
      @admin = Oriental::Relation.new(OUser).find_by(name: 'admin')
    end

    it "should return object" do
      assert_equal Oriental::RecordId.new('#5:0'), @admin.parameters[:@rid]
    end
  end
end
