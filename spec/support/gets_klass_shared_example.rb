require 'spec_helper'

shared_examples_for 'GetsKlass' do

  let(:example){ described_class.new }

  describe '#test_class' do
    it 'should not raise exception for whitelisted class' do
      expect{example.test_class(Thing).to not_raise_error}
    end
    it 'should raise exception for class not in whitelist' do
      expect{example.test_class(Meat)}.to raise_error ActionController::RoutingError
    end

    it 'should raise exception if class is nil' do
      expect{example.test_class(nil)}.to raise_error ActionController::RoutingError
    end
  end
end
