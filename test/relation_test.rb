require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Relation" do

  it "should initialize" do
    criteria = Oriental::Relation.new('User')
    assert_equal 'User', criteria.klass
  end

  it "should result with sql statement" do
    relation = Oriental::Relation.new('User').where(name: 'admin')
    assert_equal "SELECT FROM User WHERE (name = 'admin')", relation.to_sql
  end

  it "should result with sql statement for integer" do
    relation = Oriental::Relation.new('User').where(id: 1)
    assert_equal "SELECT FROM User WHERE (id = 1)", relation.to_sql
  end
end
