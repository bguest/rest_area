require "spec_helper"

describe 'GET /rest/vegetables' do
  it 'should get all the vegetables' do
    carrot = Vegetable.create(name:'carrot')
    pea = Vegetable.create(name:'pea')

    get "/rest/vegetables"
    expect(response).to be_success

    expected = {'vegetables' => [{'id' => carrot.id, 'name' => 'carrot'},
                                 {'id' => pea.id, 'name' => 'pea'}]}

    result = JSON.parse response.body
    expect(expected).to eq(result)
  end
end

describe 'GET /rest/vegetables/:key' do
  it 'should get a thing' do
    thing = Vegetable.create(name:'pickle')

    get "/rest/vegetables/#{thing.name}"

    expected = {'vegetable' => {'name' => 'pickle', 'id'=>thing.id}}
    response = JSON.parse @response.body
    response.should == expected
  end
end

describe 'DELETE /rest/vegetables/:id' do
  it 'should get all the bobs' do
    carrot = Vegetable.create(name:'carrot')

    expect{ delete "/rest/vegetables/#{carrot.name}" }.to raise_error ActionController::RoutingError
  end
end

