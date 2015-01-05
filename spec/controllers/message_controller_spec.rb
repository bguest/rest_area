require 'spec_helper'

describe RestArea::MessageController, :type => :controller do
  routes { RestArea::Engine.routes }

  it_behaves_like 'GetsKlass'

  describe '#get /rest/:klass/:id/:message' do
    it 'should send random message to object' do
      john = Thing.new(name:'john')
      john.id = 42
      Thing.stubs(:find).with('42').returns john
      get :get, klass:'thing', id:'42', message:'say_hello', :format => :json
      expect(response.body).to eq "\"hello world\""
    end

    context 'when message is in class whitelist' do

      it 'should return json of related objects' do
        cereal = Cereal.new(name:'bob', calories:300)
        cereal.things.build(name:'fred')
        cereal.things.build(name:'john')
        cereal.save

        get :get, :klass => 'cereal', :id => cereal.id, :message => 'things', :format => :json

        hash = JSON.parse(response.body)

        expected = {'things'=>[
          {'id'=> 1, 'name'=>'fred', 'array' => [], 'cereal_id' => cereal.id},
          {'id'=> 2, 'name'=>'john', 'array' => [], 'cereal_id' => cereal.id}
        ]}
        expect(hash).to eq expected
      end

      it 'should use serialized json of related objects' do
        supermarket = Supermarket.new()
        supermarket.cereals.build(name:'special_k', calories: 200)
        supermarket.cereals.build(name:'fruitloops', calories: 300)
        supermarket.save

        get :get, :klass => 'supermarkets', :id => supermarket.id, :message => 'cereals', :format => :json

        hash = JSON.parse(response.body)

        expected = {'cereals'=>[
          {'name' => 'special_k', 'calories'=>200},
          {'name' => 'fruitloops', 'calories'=>300}
        ]}
        expect(hash).to eq expected

      end

    end

    it 'should raise error for objects not in whitelist' do
      supermarket = Supermarket.new()
      supermarket.meats.build(name:'bacon')
      supermarket.save

      expect {
        get :get, :klass => 'supermarkets', :id => supermarket.id, :message => 'meats', :format => :json
      }.to raise_error ActionController::RoutingError
    end

  end

end

