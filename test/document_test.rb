require File.expand_path '../test_helper.rb', __FILE__

include Rack::Test::Methods

describe "Document" do

  before do
    @user = User.new
  end

  describe "attributes" do
    it "should include fields" do
      assert_equal [:rid, :_klass, :_type, :username], User.fields.keys
    end
  end

  describe 'basic attributes' do
    it "should include username" do
      assert @user.respond_to?(:username)
    end

    it "should include klass" do
      assert @user.respond_to?(:_klass)
    end

    it "should include type" do
      assert @user.respond_to?(:_type)
    end

    it "should have dynamic fields" do
      @user.dynamic_field(:dynamic_field, :dynamic)
      assert @user.is_dynamic_field_dynamic?
    end
  end

end
