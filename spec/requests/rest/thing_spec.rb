require "spec_helper"

describe 'GET /rest/things' do
  it 'should get all the things' do
    bob = Thing.create(name:'bob', array:[1,2])
    fred = Thing.create(name:'fred', array:[3,4])

    get "/rest/things"
    expect(response).to be_success

    expected = {'things' => [{'id' => bob.id, 'name' => 'bob', 'array' => [1,2], 'cereal_id' => nil},
                             {'id' => fred.id, 'name' => 'fred', 'array' => [3,4], 'cereal_id' => nil}]}

    result = JSON.parse response.body
    expect(expected).to eq(result)
  end
end

describe 'GET /rest/things?name=bob' do
  it 'should get all the bobs' do
    bob1 = Thing.create(name:'bob', array:[1,2])
    bob2 = Thing.create(name:'bob', array:[1])
    Thing.create(name:'fred', array:[3,4])

    get "/rest/things?name=bob"
    expect(response).to be_success

    expected = {'things' => [{'id' => bob1.id, 'name' => 'bob', 'array' => [1,2], 'cereal_id' => nil},
                             {'id' => bob2.id, 'name' => 'bob', 'array' => [1], 'cereal_id' => nil}]}

    result = JSON.parse response.body
    expect(expected).to eq(result)

  end
end

describe 'GET /rest/things/:id' do
  it 'should get a thing' do
    thing = Thing.create(name:'dan', array:[1,3])

    get "/rest/things/#{thing.id}"

    expected = {'thing' => {'name' => 'dan', 'id'=>thing.id, 'array'=>[1,3], 'cereal_id' => nil}}
    response = JSON.parse @response.body
    response.should == expected
  end
end
