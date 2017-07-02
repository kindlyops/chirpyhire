require 'rails_helper'

RSpec.describe Courier do
  describe 'call' do
    subject { Courier.new(contact, message) }

    context 'with assignment rules' do
    end

    context 'without assignment rules' do
      it 'does not call InboxCourier' do
        expect(InboxCourier).not_to receive(:call)

        subject.call
      end
    end
  end
end
