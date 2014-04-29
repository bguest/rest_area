require 'spec_helper.rb'

describe RestArea::RestController do
  routes { RestArea::Engine.routes }
  updating_rail_version = false

  describe "#index GET /rest/:klass" do
    it 'get all the things' do
      if updating_rail_version
        Thing.create(name:'bob')
        Thing.create(name:'fred')
      else
        array = [Thing.new(name: 'bob'), Thing.new(name:'fred')]
        Thing.stubs(:all).returns(array)
      end

      get :index, :klass => 'things', :format => :json

      assigns[:root].should == "thing"
      assigns[:roots].should == "things"

      response = JSON.parse @response.body
      response['things'][0]["name"].should == "bob"
      response['things'][1]["name"].should == "fred"
    end
  end

  describe "#show GET /rest/:klass/:id" do
    it 'should get the specified object' do
      thing = Thing.new(name:'dan')
      Thing.stubs(:find).with('42').returns(thing)
      thing.stubs(:save).returns(true)

      get :show, id:'42', :klass => 'things', :format => :json

      response = JSON.parse @response.body
      response['thing']['name'].should == 'dan'
    end
  end

  describe "#create POST /rest/:klass" do
    it 'be able to create object' do
      attrs = {'name' => 'chris'}
      thing = Thing.new(attrs)
      Thing.expects(:new).with(attrs).returns(thing)
      thing.stubs(:save).returns(true)

      post :create, thing:attrs, :klass => 'things', :format => :json
      response.should be_success

      response = JSON.parse @response.body
      response['thing']['name'].should == 'chris'
    end

    it "return error is can't create object" do
      attrs = {'name' => 'chris'}
      thing = Thing.new(attrs)
      thing.errors.add(:base, "are belong to us")
      Thing.expects(:new).with(attrs).returns(thing)
      thing.stubs(:save).returns(false)

      post :create, thing:attrs, :klass => 'things', :format => :json

      @response.code.should == '422'
      response = JSON.parse @response.body

      expected_response = {"errors"=>{"base"=>["are belong to us"]}}
      response.should == expected_response
    end
  end

  describe "#delete DELETE /rest/:klass/:id" do
    it 'should be able to delete object' do
      thing = Thing.new(name:'dead')
      Thing.stubs(:find).with('54').returns(thing)
      thing.stubs(:destroy).returns(thing)

      delete :delete, id:'54', :klass => 'things', :format => :json
      response.should be_success

      response = JSON.parse @response.body
      response['thing']['name'].should == 'dead'
    end

    it "return error is can't delete object" do
      thing = Thing.new(name:'alive')
      Thing.stubs(:find).with('24').returns(thing)
      thing.stubs(:destroy).returns(false)
      thing.errors.add(:base, 'are belong to us')

      delete :delete, id:'24', :klass => 'things', :format => :json

      @response.code.should == '422'
      response = JSON.parse @response.body

      expected_response = {"errors"=>{"base"=>["are belong to us"]}}
      response.should == expected_response
    end
  end
end
