require 'spec_helper'
require 'timecop'

include RestArea

describe RestArea::Resource do

  let(:resource){Resource.new(:thing)}

  describe '#class' do
    it 'should set class' do
      resource.klass.name.should == 'Thing'
    end
  end

  describe '#actions' do
    it 'should set/get actions' do
      resource.action :create, :update
      resource.action :update

      expect(resource.actions).to eq [:create, :update]
    end
  end

  describe '#read_only!' do
    it 'should add :show and :index actions' do
      resource.read_only!
      expect(resource.actions).to eq [:index, :show]
    end
  end

  describe '#messages' do
    it 'should be able to set messages' do
      resource.messages :say_hello, :say_goodbye
      expect(resource.messages).to eq [:say_hello, :say_goodbye]
    end

    it "should raise error if class does't respond to message" do
      expect{resource.messages :foobar}.to raise_error NoMethodError
    end
  end

  describe '#can_do?' do
    it 'should return true if resource has no actions' do
      expect(resource.can_do?(:create)).to be true
    end

    context 'with action :create' do
      before do resource.action :create end

      it 'should return true if can do action' do
        expect(resource.can_do?(:create)).to be true
      end

      it "should return true if can't do action" do
        expect(resource.can_do?(:delete)).to be false
      end
    end
  end

  describe '#can_send?' do
    before do resource.message :say_hello end

    it 'should return false if message is not registered' do
      expect(resource.can_send?(:foobar)).to be false
    end

    it 'should return true if message is registered' do
      expect(resource.can_send?(:say_hello)).to be true
    end

    it 'should return true if message is registered' do
      expect(resource.can_send?('say_hello')).to be true
    end

  end

  describe '#headers' do
    it 'should be able to set/get headers' do
      resource.headers( {'Cache-Control' => 'public, max-age=86400'} )
      expect(resource.headers['Cache-Control']).to eq 'public, max-age=86400'
    end

    it 'should evaluate lambdas on get' do
      Timecop.freeze Time.new(2015,01,01,0,0,0,0) do
        resource.headers= {'Expires' => ->{(Time.now + 5.days).utc.to_s}}
      end
      Timecop.freeze Time.new(2016,01,06,0,0,0,0) do
        expect(resource.headers['Expires']).to eq "2016-01-11 00:00:00 UTC"
      end
    end
  end

  describe '#headers=' do
    it 'should be able to set/get headers' do
      resource.headers= {'Cache-Control' => 'public, max-age=86400'}
      expect(resource.headers['Cache-Control']).to eq 'public, max-age=86400'
    end
  end

  describe '#key' do
    it 'should set/get key' do
      resource.key :user_id
      expect(resource.key).to eq :user_id
    end

    it 'should have default key :id' do
      expect(resource.key).to eq :id
    end
  end

end
