require 'spec_helper'

describe RestArea do
  it {should respond_to(:class_whitelist)}

  describe '.class_whitelist' do
    it 'should add resources' do
      RestArea.resources.keys.should == [:supermarket, :thing, :cereal, :vegetable]
    end
  end

  describe '.configure' do

    it 'should add resource to configuration' do
      RestArea.resources.keys.should == [:supermarket, :thing, :cereal, :vegetable]
    end

    it 'should set resource key' do
      RestArea.resources[:vegetable].key.should == :name
      RestArea.resources[:supermarket].key.should == :id
    end

  end

  describe "#find" do
    it 'should pass on to super if no key' do
      resource = RestArea.resources[:thing]
      Thing.expects(:find).with(42).returns(stub)
      resource.find(42)
    end

    it 'should pass to where().first! if key is set' do
      resource = RestArea.resources[:vegetable]
      Vegetable.expects(:where).with(:name => 'stick').returns(stub(:first! => stub))
      resource.find('stick')
    end
  end
end
