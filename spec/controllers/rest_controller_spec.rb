require 'spec_helper'

describe RestArea::RestController do
  routes { RestArea::Engine.routes }

  describe "#index GET /rest/:klass" do
    it 'get all the things' do
      if RSpec.configuration.updating_rails_version
        bob = Thing.create(name:'bob')
        fred = Thing.create(name:'fred')
      else
        bob = Thing.new(name:'bob')
        fred = Thing.new(name:'fred')
        array = [bob,fred]
        Thing.stubs(:all).returns(array)
      end

      get :index, :klass => 'things', :format => :json

      assigns[:root].should == "thing"
      assigns[:roots].should == "things"

      expected = {'things' => [{'id' => bob.id, 'name' => 'bob'}, {'id' => fred.id, 'name' => 'fred' }]}

      response = JSON.parse @response.body
      response.should == expected
    end

    it 'should respect serializers' do
      if RSpec.configuration.updating_rails_version
        special_k   = Cereal.create(name:'Special K',   calories:300)
        corn_flakes = Cereal.create(name:'Corn Flakes', calories:450)
      else
        special_k   = Cereal.new(name:'Special K', calories:300)
        corn_flakes = Cereal.new(name:'Corn Flakes', calories:450)
        special_k.stubs(:id).returns('22')
        corn_flakes.stubs(:id).returns('34')
        Cereal.stubs(:all).returns([special_k, corn_flakes])
      end

      get :index, :klass => 'cereals', :format => :json

      expected = {"cereals" => [{"id" => special_k.id, "name" => 'Special K', "calories" => 300},
                                {"id" => corn_flakes.id, "name" => 'Corn Flakes', "calories" => 450}]}
      response = JSON.parse @response.body
      response.should == expected
    end
  end

  describe "#show GET /rest/:klass/:id" do
    it 'should get the specified object' do

      if RSpec.configuration.updating_rails_version
        thing = Thing.create(name:'dan')
      else
        thing = Thing.new(name:'dan')
        Thing.stubs(:find).with('42').returns(thing)
        thing.stubs(:save).returns(true)
        thing.stubs(:id).returns(42)
      end

      get :show, id:thing.id, :klass => 'things', :format => :json

      expected = {'thing' => {'name' => 'dan', 'id'=>thing.id}}
      response = JSON.parse @response.body
      response.should == expected
    end

    it 'should respect serializers' do
      if RSpec.configuration.updating_rails_version
        crunch = Cereal.create(name:'Captin Crunch', calories:765)
      else
        crunch = Cereal.new(name:'Captin Crunch', calories:765)
        Cereal.stubs(:find).with('42').returns(crunch)
        crunch.stubs(:id).returns(42)
      end

      expected = {'cereal' => {'id'=>crunch.id, 'name'=>'Captin Crunch', 'calories' => 765}}

      get :show, id:crunch.id, :klass => 'cereals', :format => :json

      response = JSON.parse @response.body
      response.should == expected
    end
  end

  describe "#create POST /rest/:klass" do
    it 'be able to create object' do
      attrs = {'name' => 'chris'}
      thing = Thing.new(attrs)

      unless RSpec.configuration.updating_rails_version
        Thing.expects(:new).with(attrs).returns(thing)
        thing.stubs(:save).returns(true)
      end

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

    it 'should respect serializers' do
      attrs = {'name'=>'Granola', 'calories'=>123}
      unless RSpec.configuration.updating_rails_version
        crunchy = Cereal.new(attrs)
        Cereal.stubs(:new).returns(crunchy)
        crunchy.stubs(:id).returns(1)
        crunchy.stubs(:save).returns(true)
      end

      post :create, cereal:attrs, :klass => 'cereal', :format => :json

      response = JSON.parse @response.body
      expected = {'cereal' => {'id'=>1, 'name' => 'Granola', 'calories'=>123}}
      response.should == expected
    end
  end

  describe "#update PUT /rest/:klass/:id" do
    it 'be able to update object' do
      attrs = {'name' => 'chris'}

      if RSpec.configuration.updating_rails_version
        thing = Thing.create(name:'bob')
      else
        thing = Thing.new(attrs)
        thing.stubs(:id).returns(99)
        Thing.expects(:find).with('99').returns(thing)
        Thing.stubs(:update_attributes).with(attrs).returns(thing)
      end

      put :update, id:thing.id, thing:attrs, :klass => 'things', :format => :json
      response.should be_success

      response = JSON.parse @response.body
      expected = {'thing'=>{'id'=>thing.id, 'name'=>'chris'}}
      expect(response).to eq(expected)
    end

    it "return error if can't create object" do
      attrs = {'name' => 'chris'}
      thing = Thing.new(attrs)
      thing.stubs(:id).returns(99)
      thing.errors.add(:base, "are belong to us")
      Thing.expects(:find).with('99').returns(thing)
      thing.expects(:update_attributes).with(attrs).returns(false)

      put :update, id:thing.id, thing:attrs, :klass => 'things', :format => :json

      @response.code.should == '422'
      response = JSON.parse @response.body

      expected_response = {"errors"=>{"base"=>["are belong to us"]}}
      response.should == expected_response
    end

    it 'should respect serializers' do
      attrs = {'name'=>'Trixxx', 'calories'=>321}

      if RSpec.configuration.updating_rails_version
        trix = Cereal.create(name:'trix', calories:300)
      else
        trix = Cereal.new(attrs)
        trix.stubs(:id).returns(99)
        Cereal.expects(:find).with('99').returns(trix)
        Cereal.stubs(:update_attributes).with(attrs).returns(trix)
      end

      put :update, cereal:attrs, id:trix.id, :klass => 'cereal', :format => :json

      response = JSON.parse @response.body
      expected = {'cereal' => {'id'=>trix.id, 'name' => 'Trixxx', 'calories'=>321}}
      response.should == expected
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

    it 'should respect serializers' do

      if RSpec.configuration.updating_rails_version
        bran = Cereal.create(name:'All-Bran', calories:10)
      else
        bran = Cereal.new(name:'All-Bran', calories:10)
        Cereal.stubs(:find).with('44').returns(bran)
        bran.stubs(:id).returns(44)
        bran.stubs(:destroy).returns(bran)
      end

      delete :delete, id:bran.id, :klass => 'cereals', :format => :json
      response.should be_success

      response = JSON.parse @response.body
      expected = {'cereal' => {'id' => bran.id, 'name' => 'All-Bran', 'calories'=>10}}
      response.should == expected
    end
  end
end
